package com.sena.test.entity;

import io.swagger.v3.oas.annotations.media.Schema;

public class User {

    @Schema(example = "1")
    private Long id;

    @Schema(example = "valery123")
    private String username;

    @Schema(example = "valery@gmail.com")
    private String email;

    public User() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
