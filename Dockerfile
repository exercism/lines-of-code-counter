FROM public.ecr.aws/lambda/ruby:2.7 AS build

RUN yum install -y tar gzip

RUN curl -L -o /tmp/tokei.tar.gz https://github.com/XAMPPRocky/tokei/releases/download/v12.1.2/tokei-x86_64-unknown-linux-musl.tar.gz && \
    tar -xvf /tmp/tokei.tar.gz -C /usr/bin

FROM public.ecr.aws/lambda/ruby:2.7 AS runtime

COPY --from=build /usr/bin/tokei /usr/bin/tokei

RUN yum install -y gcc make

WORKDIR ${LAMBDA_TASK_ROOT}

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY lib/ lib/
COPY tracks/ tracks/

CMD [ "lib/lines_of_code_counter.LinesOfCodeCounter.process" ]
