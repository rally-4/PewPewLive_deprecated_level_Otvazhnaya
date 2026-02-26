math={}
math.e = 2.718281828459045235360287
math.pi = 3.141592653589793238462643
math.fpi = fmath.tau()/2fx
math.tau = 6.283185307179586476925286
math.ftau = fmath.tau()

-- float only
function math.floor(a) return a//1 end
function math.ceil(a) return a//1==a and a or a//1+1 end
function math.mod(a,b) return b==0 and 0 or a-b*(a//b) end
function math.remn(a) return a>0 and a or 0 end
function math.abs(a) return a>0 and a or -a end
function math.hypot(a,b) return (a*a+b*b)^.5 end
function math.sgn(a) return (a>0 and 1 or 0)-(a<0 and 1 or 0) end
function math.cen(a,b) return a>0 and math.min(a,b) or math.max(a,-b) end

function math.norm(u,o,x)
    return u*math.e^(-.5*x^2/o^2)/o
end
function math.sin(a) a=a%math.tau
    local t,sgn,result=1,1,0
    for i=1,24 do
        result=result+sgn*t
        sgn=-sgn
        t=.5*t*a*a/i/(2*i-1)
    end
    return result
end

-- float or fixedpoint
function math.min(a,b) return a<b and a or b end
function math.max(a,b) return a>b and a or b end
function math.clamp(a,b,c) return a<b and b or a>c and c or a end

function math.reflect(x,y,nx,ny)
    local dot=x*nx+y*ny
    dot=dot+dot
    return x-nx*dot,y-ny*dot
end

-- fixedpoint only
function math.fabs(a) return a>0fx and a or -a end
function math.fhypot(a,b) return fmath.sqrt(a*a+b*b) end
function math.fsgn(a) return (a>0fx and 1fx or 0fx)-(a<0fx and 1fx or 0fx) end
function math.fcen(a,b) return a>0fx and math.min(a,b) or math.max(a,-b) end

function math.fnormalise(a,b)
    local len=fmath.sqrt(a*a+b*b)
    return a/len,b/len
end

return math