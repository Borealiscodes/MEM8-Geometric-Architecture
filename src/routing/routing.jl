module Routing

export select_route

select_route(z, routes) = routes[argmax([dot(z, r.v) for r in routes])]

end
