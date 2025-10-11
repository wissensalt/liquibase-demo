# Liquibase Demo Project

[![MySQL DB Migration](https://github.com/wissensalt/liquibase-demo/actions/workflows/liquibase-mysql.yml/badge.svg?branch=master)](https://github.com/wissensalt/liquibase-demo/actions/workflows/liquibase-mysql.yml)

[![YAML Lint](https://github.com/wissensalt/liquibase-demo/actions/workflows/yamllint.yaml/badge.svg?branch=master)](https://github.com/wissensalt/liquibase-demo/actions/workflows/yamllint.yaml)

A comprehensive demonstration of database migration management using Liquibase with different
database technologies and deployment scenarios.

## Requirements

1. Support multi databases
2. Simple with raw SQL query, easy to use and maintain
3. Standalone as migration tool, no need to integrate with any programming language
4. Allow Rollbacks to undo a database change
5. Tracking schema change & version control
6. Support multiple environments (development, staging, production)
7. Containerized with Docker for easy setup and teardown
8. Automated tasks for common operations
9. CI/CD integration for automated deployments

## 🎯 Overview

This project showcases various Liquibase implementations across different branches, demonstrating
database migration best practices with Docker containerization, automated task management, and *
*GitHub Actions CI/CD pipelines**.

## 🔥 New: GitHub Actions Integration

This repository now includes comprehensive GitHub Actions workflows for secure database migrations
on your VPS!

- 🚀 **Automated migrations** on push to main branch
- 🔒 **Secure credential management** with GitHub Secrets
- 🎯 **Manual operation triggers** for all `Taskfile` commands
- 📊 **Environment-specific deployments** (dev/staging/prod)
- ✅ **PR validation** with SQL preview generation

📖 **[Complete GitHub Actions Setup Guide](./GITHUB_ACTIONS_GUIDE.md)**

## 🌟 Features

- **Multi-Database Support**: MySQL and MongoDB implementations
- **Docker Integration**: Fully containerized development environment
- **Automated Tasks**: Task runner for common operations
- **Multiple Scenarios**: Different migration patterns across branches
- **YAML Configurations**: Clean, readable changeset definitions

## 🏗️ Project Structure

```
liquibase-demo/
├── changelogs/                 # Database changesets
│   ├── changelog-root.yaml     # Main changelog orchestrator
│   ├── 001-create-users-table.yaml
│   ├── 002-insert-users-data.yaml
│   ├── 003-add-created-at-column.yaml
│   └── 004-add-index-username.yaml
├── drivers/                    # Database drivers
│   └── mysql-connector-j-9.4.0.jar
├── scripts/                    # Initialization scripts
│   └── init-db.sh
├── data/                       # Database persistent storage
├── docker-compose.yml          # Container orchestration
├── database.env               # Environment variables
├── liquibase.properties       # Liquibase configuration
└── Taskfile.yml              # Task automation
```

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- [Task](https://taskfile.dev/) (optional, for automation)

### Setup & Run

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd liquibase-demo
   ```

2. **Start the services:**
   ```bash
   # Using Task (recommended)
   task start-server
   
   # Or using Docker Compose directly
   docker compose up -d
   ```

3. **Run migrations:**
   ```bash
   task migrate
   ```

## 📋 Available Tasks

### Local Development (Docker)

| Task                       | Description                                             |
|----------------------------|---------------------------------------------------------|
| `task start-server`        | Start MySQL server + Liquibase CLI using Docker         |
| `task stop-server`         | Stop Docker containers                                  |
| `task migrate`             | Run database migrations                                 |
| `task rollback`            | Rollback last migration                                 |
| `task status`              | Check migration status                                  |
| `task history`             | Show migration history                                  |
| `task sync-db`             | Sync database with changelog without running migrations |
| `task generate-change-log` | Generate changelog from existing database               |
| `task clear`               | Clear migration checksums                               |

### Production/VPS (GitHub Actions)

All tasks above are available via GitHub Actions workflows for secure VPS database operations:

- 🎯 **Manual Triggers**: Run any operation on-demand through GitHub Actions UI
- 🔄 **Automatic Migrations**: Auto-deploy on push to main branch
- 🛡️ **Secure Credentials**: Environment-specific secret management
- 📊 **Multi-Environment**: Support for dev/staging/production environments

**[📖 See complete GitHub Actions setup guide](./GITHUB_ACTIONS_GUIDE.md)**

## 🌿 Branch Overview

### `master` (Current)

- **Database**: MySQL 8
- **Features**: Basic user table management with structured changesets
- **Changesets**: Table creation, data insertion, schema modifications, indexing

### `existing-db`

- **Database**: MySQL 8 with pre-existing tables
- **Features**: Database initialization script + Liquibase sync
- **Use Case**: Working with existing database schemas

### `mongodb`

- **Database**: MongoDB 7.0.6
- **Features**: NoSQL migration using raw MongoDB commands
- **Changesets**: Collection creation, document insertion, index management

### `multi-database`

- **Database**: Multiple MySQL databases
- **Features**: Cross-database migration management
- **Use Case**: Multi-tenant or microservices architecture

### `yaml-sql`

- **Database**: MySQL with YAML-formatted SQL changesets
- **Features**: Mixed SQL/YAML configuration approach

## 🔧 Configuration

### Database Connection

The project uses environment-based configuration:

```properties
# liquibase.properties
url=jdbc:mysql://mysql:3306/liquibase_db
username=user
password=password
driver=com.mysql.cj.jdbc.Driver
```

### Environment Variables

```bash
# database.env
MYSQL_DATABASE=liquibase_db
MYSQL_USER=user
MYSQL_PASSWORD=password
MYSQL_ROOT_PASSWORD=password
```

## 📊 Database Schema

### Users Table Structure

```sql
CREATE TABLE users
(
    id         INT AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50)  NOT NULL UNIQUE,
    email      VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Sample Data

- **alice**: alice@example.com
- **bob**: bob@example.com

## 🐳 Docker Services

| Service     | Image                           | Purpose                 | Port |
|-------------|---------------------------------|-------------------------|------|
| `mysql`     | mysql:8                         | Database server         | 3306 |
| `liquibase` | liquibase/liquibase:4.33-alpine | Migration tool          | -    |
| `db-init`   | mysql:8                         | Database initialization | -    |

## 🔄 Migration Workflow

1. **Database Startup**: MySQL container initializes
2. **Schema Creation**: Liquibase applies changesets sequentially
3. **Data Population**: Insert sample data
4. **Schema Evolution**: Add columns, indexes as needed
5. **Rollback Support**: Each changeset includes rollback instructions

## 🛠️ Development Guidelines

### Creating New Changesets

1. **File naming**: Use sequential numbering (e.g., `005-add-user-roles.yaml`)
2. **Include in root**: Add to `changelog-root.yaml`
3. **Rollback support**: Always include rollback instructions
4. **Test locally**: Verify with `task migrate` and `task rollback`

### Changeset Structure

```yaml
databaseChangeLog:
  - changeSet:
      id: 5
      author: your-name
      changes:
        - createTable:
            tableName: your_table
            # ... table definition
      rollback:
        - dropTable:
            tableName: your_table
```

## 🚨 Troubleshooting

### Common Issues

1. **Permission Denied (init-db.sh)**
   ```bash
   chmod +x scripts/init-db.sh
   ```

2. **MySQL Connection Refused**
   ```bash
   # Wait for MySQL to be ready
   task status
   ```

3. **Checksum Validation Failed**
   ```bash
   task clear
   task migrate
   ```

### Logs & Debugging

```bash
# Check container logs
docker logs mysql
docker logs liquibase_cli

# Check migration status
task status
task history
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add/modify changesets following naming conventions
4. Test migrations with `task migrate` and `task rollback`
5. Submit a pull request

## 📚 Resources

- [Liquibase Documentation](https://docs.liquibase.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Task Documentation](https://taskfile.dev/)
- [MySQL Documentation](https://dev.mysql.com/doc/)

## 📄 License

This project is for demonstration purposes. Feel free to use and modify as needed.

---

*Built with ❤️ for learning database migration best practices*