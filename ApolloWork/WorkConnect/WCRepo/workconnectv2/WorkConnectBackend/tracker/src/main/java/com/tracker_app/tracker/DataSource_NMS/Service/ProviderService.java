package com.tracker_app.tracker.DataSource_NMS.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.tracker_app.tracker.DataSource_NMS.Entity.Provider;
import com.tracker_app.tracker.DataSource_NMS.Repo.ProviderRepository;
import java.util.List;

@Service
public class ProviderService {

    @Autowired
    private ProviderRepository repository;

    public List<Provider> getAllProviders() {
        return repository.findAll();
    }
}
