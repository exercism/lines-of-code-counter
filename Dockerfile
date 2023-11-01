FROM public.ecr.aws/lambda/ruby:2.7 AS build

RUN yum install gcc make -y

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
WORKDIR ${LAMBDA_TASK_ROOT}
COPY Gemfile Gemfile.lock ./
RUN bundle install

RUN cargo install --git https://github.com/exercism/tokei tokei

FROM public.ecr.aws/lambda/ruby:2.7 AS runtime

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
WORKDIR ${LAMBDA_TASK_ROOT}

COPY --from=build /root/.cargo/bin/tokei /usr/bin/tokei
COPY --from=build ${LAMBDA_TASK_ROOT}/ ${LAMBDA_TASK_ROOT}/
COPY tokei.toml .
COPY lib/ lib/
COPY tracks/ tracks/

CMD [ "lib/lines_of_code_counter.LinesOfCodeCounter.process" ]
