package com.sena.test.service.bill;

import java.util.List;
import com.sena.test.entity.bill.Bill;

public interface IBillService {

    List<Bill> findAll();

    Bill save(Bill bill);

    void delete(Long id);
}
