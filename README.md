# TRIVIO

![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![Hotwire](https://img.shields.io/badge/Hotwire-563D7C?style=for-the-badge&logo=hotwire&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)

Trivio is a full-stack,stock trading/invesment application built with Ruby on Rails and Hotwire.
Users can invest in real companies with live market data,without spending any money.
**Trivio's** desing was inspired by [Robinhood's](https://robinhood.com/us/en/) web application.

## Features

* **Risk-Free Paper Trading**: Buy and sell real stocks using virtual currency.
* **Live Market Data**: Track real-time stock prices and company information via the [Finnhub API](https://finnhub.io/).
* **Modern, Reactive UI**: A Robinhood-inspired interface delivering seamless page transitions and updates without
  full-page reloads using Hotwire (Turbo & Stimulus).
* **Portfolio Management**: Easily view your holdings, total account value, and historical performance.
* **Docker Support**: Containerized development environment for easy setup.

## 🛠 Tech Stack

* **Backend**: Ruby on Rails
* **Frontend**: HTML, Tailwind CSS, Hotwire (Turbo)
* **Database**: PostgreSQL,Redis
* **Deployment/DevOps**: Docker
* **Code Quality**: RuboCop

## 🚀 Getting Started

Follow these instructions to set up the project locally on your machine for development and testing.

### Prerequisites

Ensure you have the following installed on your local machine:

* [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
  (Check `.ruby-version` for the exact version)

* [PostgreSQL](https://www.postgresql.org/download/)
* [Node.js & Yarn](https://yarnpkg.com/getting-started/install)
* [Docker & Docker Compose](https://docs.docker.com/get-docker/) (Optional, but recommended for containerized setup)

### Local Setup (Standard)

Install dependencies:

```bash
bundle install
yarn install
```

Create ENV Files:

.env.development
.env.test
.env.production

#### Add your PostgreSQL password:

```bash
PG_PASSWORD="your_postgres_password"
```

#### Set up Rails credentials:

```bash
EDITOR="nano" bin/rails credentials:edit
```

#### Add your Finnhub API key:

```bash
finnhub:
  api_key: "your_finnhub_api_key"
```

#### Run database migrations:

```bash
bin/rails db:create db:migrate db:seed
```

## Docker Setup (Recommended)

#### Pull the prebuilt Docker image:

```bash 
docker pull nospoon1919/trivio_dev
```

Use the included **bin/docker-dev** script to build or start the development environment.

#### Check the script for usage details:

```bash 
bin/docker-dev build   # Build Docker container
bin/docker-dev up      # Start container
```

## Contributing

1. Contributions are welcome! If you have a suggestion that would make this better, please fork the repo and create a
   pull request.

2. Fork the Project
3. Create your Feature Branch
   `(git checkout -b feature/AmazingFeature)`
4. Commit your Changes
   `
   (git commit -m 'Add some AmazingFeature')`
5. Push to the Branch
   `(git push origin feature/AmazingFeature)
   `
6. Open a Pull Request

## License

**MIT**  [License](LICENSE) © 2026
