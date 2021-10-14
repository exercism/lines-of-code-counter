FROM public.ecr.aws/lambda/ruby:2.7 AS build

RUN yum install -y tar gzip

WORKDIR /tmp
RUN curl -L -O https://github.com/XAMPPRocky/tokei/releases/download/v12.1.2/tokei-x86_64-unknown-linux-musl.tar.gz
RUN tar -xvf tokei-x86_64-unknown-linux-musl.tar.gz
RUN cp tokei /usr/bin

FROM public.ecr.aws/lambda/ruby:2.7 AS runtime

COPY --from=build /usr/bin/tokei /usr/bin/tokei

ENV GEM_HOME=${LAMBDA_TASK_ROOT}

WORKDIR ${LAMBDA_TASK_ROOT}

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY app.rb .

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "app.LambdaFunction::Handler.process" ]