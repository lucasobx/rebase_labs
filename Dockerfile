FROM ruby:3.2

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

CMD ["ruby", "app/main.rb"]