package com.sena.test.service.impl.bill;

import org.springframework.stereotype.Service;
import java.util.List;

import com.sena.test.entity.bill.BillDetail;
import com.sena.test.repository.bill.IBillDetailRepository;
import com.sena.test.service.bill.IBillDetailService;

@Service
public class BillDetailServiceImpl implements IBillDetailService {

    private final IBillDetailRepository repository;

    public BillDetailServiceImpl(IBillDetailRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<BillDetail> findAll() {
        return repository.findAll();
    }

    @Override
    public BillDetail save(BillDetail detail) {
        return repository.save(detail);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }
}