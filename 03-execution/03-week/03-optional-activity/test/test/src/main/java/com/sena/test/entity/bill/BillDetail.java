package com.sena.test.entity.bill;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import com.sena.test.entity.inventory.Product;

@Entity
@Table(name = "bill_details")
@Getter
@Setter
public class BillDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private int quantity;

    private double price;

    @ManyToOne
    @JoinColumn(name = "bill_id")
    private Bill bill;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;
}