package com.sena.test.repository.bill;

import com.sena.test.entity.bill.Bill;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IBillRepository extends JpaRepository<Bill, Long> {
}