package com.sena.test.controller.bill;

import java.util.List;
import org.springframework.web.bind.annotation.*;

import com.sena.test.entity.bill.Bill;
import com.sena.test.service.bill.IBillService;

@RestController
@RequestMapping("/api/bills")
public class BillController {

    private final IBillService service;

    public BillController(IBillService service) {
        this.service = service;
    }

    @GetMapping
    public List<Bill> getAll() {
        return service.findAll();
    }

    @PostMapping
    public Bill save(@RequestBody Bill bill) {
        return service.save(bill);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}
