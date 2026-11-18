FROM public.ecr.aws/lambda/ruby:4.0.2026.10.31.17 AS build

RUN dnf install gcc make -y

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
WORKDIR ${LAMBDA_TASK_ROOT}
COPY Gemfile Gemfile.lock ./
RUN bundle config set deployment 'true' && \
    bundle config set without 'development test' && \
    bundle install

# The exact commit of exercism/tokei (our fork) that we build and run.
# This is the fork's master at the time it was pinned.
# To move to a newer tokei, change this SHA in a PR, so the golden tests run before it can deploy.
# Changing the SHA also busts the Docker cache for the tokei build.
ARG TOKEI_SHA=1b423ca20090cad5b966729f1072b5ecb1cfb1d1
RUN cargo install --git https://github.com/exercism/tokei --rev ${TOKEI_SHA} tokei

FROM public.ecr.aws/lambda/ruby:4.0.2026.10.31.17 AS runtime

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
WORKDIR ${LAMBDA_TASK_ROOT}

COPY --from=build /root/.cargo/bin/tokei /usr/bin/tokei
COPY --from=build ${LAMBDA_TASK_ROOT}/ ${LAMBDA_TASK_ROOT}/
COPY tokei.toml .
COPY lib/ lib/
COPY tracks/ tracks/

CMD [ "lib/lines_of_code_counter.LinesOfCodeCounter.process" ]
