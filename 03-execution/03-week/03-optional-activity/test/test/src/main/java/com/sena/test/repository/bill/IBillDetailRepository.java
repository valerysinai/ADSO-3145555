package com.sena.test.repository.bill;

import com.sena.test.entity.bill.BillDetail;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IBillDetailRepository extends JpaRepository<BillDetail, Long> {
}
