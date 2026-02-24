package com.sena.test.entity;

import io.swagger.v3.oas.annotations.media.Schema;

public class UserRole {

    @Schema(example = "1")
    private Long id;

    @Schema(example = "ADMIN")
    private String roleName;

    public UserRole() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
}