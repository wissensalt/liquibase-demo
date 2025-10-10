# GitHub Secrets Configuration for Liquibase Database Migration

This document outlines the required GitHub repository secrets for secure database operations.

## Required Secrets

Configure the following secrets in your GitHub repository settings (
`Settings > Secrets and variables > Actions`):

### Database Connection Secrets

| Secret Name   | Description                            | Example Value                        | Required                      |
|---------------|----------------------------------------|--------------------------------------|-------------------------------|
| `DB_HOST`     | Database server hostname or IP address | `your-vps-ip.com` or `192.168.1.100` | ✅ Yes                         |
| `DB_PORT`     | Database server port                   | `3306`                               | ❌ Optional (defaults to 3306) |
| `DB_NAME`     | Database name                          | `liquibase_db`                       | ✅ Yes                         |
| `DB_USERNAME` | Database username                      | `liquibase_user`                     | ✅ Yes                         |
| `DB_PASSWORD` | Database password                      | `your-secure-password`               | ✅ Yes                         |

## Security Best Practices

### 1. Database User Permissions

Create a dedicated database user for Liquibase operations with minimal required permissions:

```sql
-- Connect as root or admin user
CREATE USER 'liquibase_user'@'%' IDENTIFIED BY 'your-secure-password';

-- Grant only necessary permissions
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX ON liquibase_db.* TO 'liquibase_user'@'%';

-- Grant permissions for Liquibase tracking tables
GRANT CREATE, DROP, ALTER ON liquibase_db.DATABASECHANGELOG TO 'liquibase_user'@'%';
GRANT CREATE, DROP, ALTER ON liquibase_db.DATABASECHANGELOGLOCK TO 'liquibase_user'@'%';

FLUSH PRIVILEGES;
```

### 2. Network Security

- **Firewall**: Restrict database access to specific IP addresses (GitHub Actions IP ranges)
- **SSL/TLS**: Enable encrypted connections to your database
- **VPN**: Consider using a VPN for additional security layer

### 3. Password Security

- Use strong, unique passwords (minimum 16 characters)
- Consider using password managers
- Rotate passwords regularly
- Never commit passwords to version control

### 4. GitHub Repository Security

- Enable branch protection rules
- Require pull request reviews for changelog modifications
- Enable "Restrict pushes that create files" to prevent accidental secret exposure
- Use environment protection rules for production deployments

### 5. Monitoring and Auditing

- Enable database audit logging
- Monitor for unauthorized access attempts
- Set up alerts for failed authentication attempts
- Review GitHub Actions logs regularly

## Environment-Specific Configuration

### Development Environment

```bash
# For development, you can use environment-specific secrets
DB_HOST_DEV=dev-database.company.com
DB_NAME_DEV=liquibase_db_dev
```

### Staging Environment

```bash
DB_HOST_STAGING=staging-database.company.com
DB_NAME_STAGING=liquibase_db_staging
```

### Production Environment

```bash
DB_HOST_PRODUCTION=prod-database.company.com
DB_NAME_PRODUCTION=liquibase_db_prod
```

## Setting Up Secrets

1. Navigate to your GitHub repository
2. Go to `Settings > Secrets and variables > Actions`
3. Click "New repository secret"
4. Add each required secret with its corresponding value
5. Save the secrets

## Troubleshooting

### Connection Issues

If you encounter database connection issues:

1. Verify all secrets are correctly set
2. Check database server firewall settings
3. Ensure the database user has necessary permissions
4. Test connection from a similar environment

### Permission Issues

If you get permission errors:

1. Verify the database user has all required grants
2. Check if the database exists
3. Ensure Liquibase can create its tracking tables

## Additional Security Measures

### IP Whitelisting

GitHub Actions runners use dynamic IP addresses. For enhanced security, consider:

1. Using GitHub's published IP ranges
2. Implementing a VPN solution
3. Using a bastion host for database access

### Connection Encryption

Add SSL parameters to your connection URL:

```
url=jdbc:mysql://your-host:3306/your-db?useSSL=true&requireSSL=true&verifyServerCertificate=true
```

### Backup Strategy

Before running migrations in production:

1. Create database backups
2. Test migrations in staging environment
3. Have rollback procedures ready
4. Monitor application health post-migration