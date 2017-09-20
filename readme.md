# GetSwift Code Challenge

**NOTE**: To run this script make sure that ruby is installed. Then run `ruby match.rb` in the terminal.

## The Problem
How to efficiently match drones to packages in such a way that ensures packages will be delivered by the deadline?

## Solution
Given the '`Packages should be assigned to the drone that can deliver it soonest`' constraint, there was no way around sorting the lists in some way. I didn't want to create a bloated application that will affect run-time so I avoided creating additional data-structures such as Heaps (priority queues) and placing the drones and packages in them. Instead, my approach was to sort both lists based on the these criteria:

* Packages were sorted based on deadline
* Drones were sorted based on distance to depot  
**Note**: instead of using the Haversine formula or the law of cosines, I've used Euclidean distance since it's very accurate for short ranges (0.4% error for a 50km range) and much less expensive to compute.

After sorting, the most urgent packages are at the top of the packages list and the drones that are capable of delivering them fastest are at the the top of the drones list, hence it's easy to iterate and make a match.

We first try to match the closest drone to the depot with the most urgent delivery. If that drone can't make it in time, no other drone in the list will, so that package will remain unassigned. The drone will try to be matched with the next package and so on. This ensures that each packages is matched with the drone who can deliver it soonest.

Sorting both lists takes `O(nlog(n))` time and the matching process itself is of linear time complexity. As a result, the proposed solution is of `O(nlog(n))`.


## Scalably
This approach works well for a limited number of drones and packages but will not scale up to serve thousands of dispatches a second.
To scale up there are two approaches we can take:
1. Keeping the same constraints: divide the geographical area into sub sections, and allow for parallel computations. Meaning that instead of one source of all drones, will have multiple sources of drones that cover a smaller area. This will ensure that each process is only in charge of a limited number of assignments and multiple processes can run simultaneously 
2. Relaxing the constraints: instead of ensuring that each package will be delivered by the drone that can deliver it soonest, we can have a drone deliver a package *if it can* deliver it in time. Furthermore, once we have more data, we can develope heuristics to determine if a drone can be dispatched without having to sort the array. This allows for `O(n)` time complexity.

Ideally we would have a hybrid of both approaches.