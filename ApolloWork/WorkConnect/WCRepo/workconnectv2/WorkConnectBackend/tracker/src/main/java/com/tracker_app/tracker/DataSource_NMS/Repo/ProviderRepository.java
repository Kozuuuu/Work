package com.tracker_app.tracker.DataSource_NMS.Repo;

import org.springframework.data.jpa.repository.JpaRepository;
import com.tracker_app.tracker.DataSource_NMS.Entity.Provider;

public interface ProviderRepository extends JpaRepository<Provider, Integer> {
}
