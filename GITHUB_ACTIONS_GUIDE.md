# Liquibase GitHub Actions Migration Guide

This repository now includes comprehensive GitHub Actions workflows to manage database migrations
using Liquibase on your VPS MySQL database. The workflows provide secure, automated database
operations equivalent to your existing `Taskfile.yml` commands.

## 🚀 Quick Start

### 1. Set Up GitHub Secrets

Configure the following secrets in your GitHub repository (
`Settings > Secrets and variables > Actions`):

| Secret        | Description                                | Example                |
|---------------|--------------------------------------------|------------------------|
| `DB_HOST`     | Your VPS database hostname/IP              | `your-vps.example.com` |
| `DB_PORT`     | Database port (optional, defaults to 3306) | `3306`                 |
| `DB_NAME`     | Database name                              | `liquibase_db`         |
| `DB_USERNAME` | Database username                          | `liquibase_user`       |
| `DB_PASSWORD` | Database password                          | `your-secure-password` |

### 2. Create Environment Protection (Optional but Recommended)

For production safety, set up environment protection rules:

1. Go to `Settings > Environments`
2. Create environments: `development`, `staging`, `production`
3. Configure protection rules (required reviewers, deployment branches, etc.)

## 📋 Available Workflows

### Main Liquibase Workflow (`liquibase.yml`)

**Triggers:**

- Manual dispatch with operation selection
- Automatic migration on push to `main`/`master` (when changelog files change)
- Validation on pull requests

**Features:**

- ✅ Secure credential handling
- ✅ Database connectivity validation
- ✅ Post-operation status checks
- ✅ SQL preview for pull requests
- ✅ Database health monitoring

## 🎯 Usage Examples

### Running Migrations

#### Automatic (Recommended for CI/CD)

```bash
# Push changes to main branch - triggers automatic migration
git add changelogs/005-new-feature.yaml
git commit -m "Add new feature migration"
git push origin main
```

#### Manual Execution

1. Go to `Actions` tab in your GitHub repository
2. Select "Database Migration with Liquibase"
3. Click "Run workflow"
4. Choose operation: `migrate`
5. Click "Run workflow"

### Rolling Back Changes

1. Go to `Actions` tab
2. Select "Individual Liquibase Operations"
3. Click "Run workflow"
4. Choose:
    - Operation: `rollback`
    - Rollback count: `1` (or desired number)
    - Environment: `production`
5. Click "Run workflow"

### Checking Status

1. Go to `Actions` tab
2. Select "Individual Liquibase Operations"
3. Click "Run workflow"
4. Choose operation: `status`
5. Select target environment
6. Click "Run workflow"

## 🔒 Security Features

### Database Connection Security

- All credentials stored as GitHub secrets
- No sensitive data in workflow files
- Secure property file generation at runtime

### Access Control

- Environment-based protection rules
- Manual approval for production deployments
- Audit trail for all operations

### Network Security

- Supports SSL/TLS database connections
- IP whitelisting recommendations
- VPN integration guidelines

## 🔧 Equivalent Commands

| Taskfile Command    | GitHub Actions Equivalent             |
|---------------------|---------------------------------------|
| `task start-server` | Not applicable (uses VPS database)    |
| `task stop-server`  | Not applicable (uses VPS database)    |
| `task migrate`      | Manual workflow: "migrate" operation  |
| `task rollback`     | Manual workflow: "rollback" operation |
| `task status`       | Manual workflow: "status" operation   |
| `task history`      | Manual workflow: "history" operation  |
| `task clear`        | Manual workflow: "clear" operation    |

## 📁 Workflow Structure

```
.github/
├── workflows/
│   ├── liquibase-mysql.yml              # Main workflow with auto-triggers
└── SECURITY.md                    # Security configuration guide
```

## 🛠️ Configuration Details

### Automatic Triggers

The main workflow automatically triggers on:

1. **Push to main/master** (when these files change):
    - `changelogs/**`
    - `liquibase.properties`
    - `drivers/**`

2. **Pull Request** (validation only):
    - Validates changelog syntax
    - Generates SQL preview
    - Checks for pending changes

### Manual Operations

Both workflows support manual triggering with:

- Operation selection (migrate, rollback, status, history, clear)
- Environment selection (development, staging, production)
- Rollback count specification (for rollback operations)

## 🚨 Important Notes

### Before First Use

1. **Database User Setup**: Create a dedicated user with appropriate permissions:
   ```sql
   CREATE USER 'liquibase_user'@'%' IDENTIFIED BY 'secure-password';
   GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX ON liquibase_db.* TO 'liquibase_user'@'%';
   FLUSH PRIVILEGES;
   ```

2. **Firewall Configuration**: Ensure GitHub Actions can reach your VPS database
3. **Backup Strategy**: Always backup before production migrations

### Monitoring and Troubleshooting

- Check workflow logs in the Actions tab
- Database connectivity issues often relate to firewall or credentials
- Use the health check job to validate setup

## 🔄 Migration Best Practices

1. **Test in Development First**: Always test migrations in development environment
2. **Use Pull Requests**: Leverage automatic validation on PRs
3. **Review SQL Previews**: Check generated SQL before production deployment
4. **Backup Before Migration**: Always backup production data
5. **Monitor After Migration**: Check application health post-migration

## 📖 Additional Resources

- [Liquibase Documentation](https://docs.liquibase.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [MySQL JDBC Driver Documentation](https://dev.mysql.com/doc/connector-j/8.0/en/)
- [Security Best Practices](./.github/SECURITY.md)

## 🆘 Support

If you encounter issues:

1. Check the [Security Guide](./.github/SECURITY.md)
2. Review workflow logs in the Actions tab
3. Verify all secrets are properly configured
4. Test database connectivity from your local environment

---

## 🔧 Local Development

You can still use the existing `Taskfile.yml` for local development with Docker:

```bash
# Start local MySQL + Liquibase containers
task start-server

# Run local migrations
task migrate

# Check local status
task status

# Stop local containers
task stop-server
```

The GitHub Actions workflows are designed to work alongside your existing local development setup.