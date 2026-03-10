package com.sena.test.service.impl.bill;

import org.springframework.stereotype.Service;
import java.util.List;

import com.sena.test.entity.bill.Bill;
import com.sena.test.repository.bill.IBillRepository;
import com.sena.test.service.bill.IBillService;

@Service
public class BillServiceImpl implements IBillService {

    private final IBillRepository repository;

    public BillServiceImpl(IBillRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<Bill> findAll() {
        return repository.findAll();
    }

    @Override
    public Bill save(Bill bill) {
        return repository.save(bill);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}