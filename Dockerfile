FROM public.ecr.aws/lambda/ruby:2.7 AS build

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

RUN yum install gcc -y

RUN cargo install --git https://github.com/XAMPPRocky/tokei.git tokei

FROM public.ecr.aws/lambda/ruby:2.7 AS runtime

COPY --from=build /root/.cargo/bin/tokei /usr/bin/tokei

RUN yum install -y gcc make

WORKDIR ${LAMBDA_TASK_ROOT}

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY tokei.toml .
COPY lib/ lib/
COPY tracks/ tracks/

CMD [ "lib/lines_of_code_counter.LinesOfCodeCounter.process" ]
