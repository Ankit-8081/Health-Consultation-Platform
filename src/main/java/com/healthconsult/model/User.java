package com.healthconsult.model;

/**
 * Base class of every account (rubric: OOP). Subclasses decide their {@link Role} and dashboard,
 * so callers can write {@code user.getDashboardPath()} without checking the type (polymorphism).
 */
public abstract class User {

    private int userId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String phone;
    private UserStatus status;

    protected User(int userId, String fullName, String email, String passwordHash, String phone, UserStatus status) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
        this.status = status;
    }

    public abstract Role getRole();

    public abstract String getDashboardPath();

    /** True if this user may open the URL path. Role-owned prefixes (/admin/, /pro/, /patient/) need the matching role. */
    public boolean canAccess(String path) {
        return Role.forPath(path).map(required -> required == getRole()).orElse(true);
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public UserStatus getStatus() { return status; }
    public void setStatus(UserStatus status) { this.status = status; }

    @Override
    public String toString() {
        // never include the password hash
        return getClass().getSimpleName() + "{id=" + userId + ", email=" + email + ", role=" + getRole() + "}";
    }
}
