package com.sena.test.service.bill;

import java.util.List;
import com.sena.test.entity.bill.BillDetail;

public interface IBillDetailService {

    List<BillDetail> findAll();

    BillDetail save(BillDetail detail);

    void delete(Long id);
}