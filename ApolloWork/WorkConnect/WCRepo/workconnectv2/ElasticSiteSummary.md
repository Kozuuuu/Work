## Elastic Site Summary Documentation
Work-connect data flow

> Data Source comes from elastic cluster (http://202.60.12.112:11500)

### Getting the wireless only value
Incremented variables:
 - total cirucits
 - primary no internet
 - circuits up
 - wireless up
 - primary wireless
 - primary circuit less than 95% uptime availablity
 - wireless only
 
 
 
```
For each circuit in the list of circuits:
     for ( Loop trough site circuit status)
       if (site circuit type is equals to "LOOPBACK 0") 
           if (site circuit is equals to "primary")
               increment number of circuits
               
               if(site circuit status is equals to "down")
                   increment primary no internet
               else
                   increment primary up 
                   increment nnumber of circuits up
               
               if(site circuit contains "SIM")
                   increment number of wireless up
                   increment number of primary wireless
               if(site circuit uptime < 0.95)
                   increment primary circuit less than 95% uptime availablity
       
   if(number of wireless up is equals to number of circuits up OR 
       number of wireless up is equals to number of circuits)
       increment wirelss only
       
```

