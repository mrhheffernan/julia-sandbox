# Math's hello world: Calculating pi via Monte Carlo
using Plots

n_samples = parse(Int64, ARGS[1]::String) # Allow user to specify number of samples
radius = 1

function check(sample_x, sample_y)
    # Check if sample is in the circle
    sample_radius = (sample_x ^ 2 + sample_y ^ 2)^0.5
    return sample_radius < radius
end

function integrate_quadrant(n_samples)
    success = 0    
    samples = rand(n_samples, 2) # 2D integration only
    samples_inside = []
    samples_outside = []

    for i in 1:n_samples
        checker = check(samples[i,1], samples[i,2])
        if checker
            success = success + 1
            push!(samples_inside, samples[i,:])
        else
            push!(samples_outside, samples[i,:])
        end
    end
    return success / n_samples, samples, reduce(vcat, transpose.(samples_inside)), reduce(vcat, transpose.(samples_outside))
end

quadrant, samples, samples_inside, samples_outside = integrate_quadrant(n_samples)
pi_estimate = 4 * quadrant

println("pi: ", pi_estimate)

p = plot(samples_inside[:,1], samples_inside[:,2], seriestype=:scatter, label="Samples: Inside")
plot!(samples_outside[:,1], samples_outside[:,2], seriestype=:scatter, label="Samples: Outside")

xlabel!("X Coordinate")
ylabel!("Y Coordinate")
savefig(p, "plot.png")