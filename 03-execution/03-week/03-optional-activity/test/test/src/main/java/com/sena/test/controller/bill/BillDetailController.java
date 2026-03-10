package com.sena.test.controller.bill;

import java.util.List;
import org.springframework.web.bind.annotation.*;

import com.sena.test.entity.bill.BillDetail;
import com.sena.test.service.bill.IBillDetailService;

@RestController
@RequestMapping("/api/bill-details")
public class BillDetailController {

    private final IBillDetailService service;

    public BillDetailController(IBillDetailService service) {
        this.service = service;
    }

    @GetMapping
    public List<BillDetail> getAll() {
        return service.findAll();
    }

    @PostMapping
    public BillDetail save(@RequestBody BillDetail detail) {
        return service.save(detail);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}