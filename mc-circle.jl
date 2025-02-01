# Math's hello world: Calculating pi via Monte Carlo
import Plots: plot, plot!, savefig
using ArgParse: ArgParseSettings, @add_arg_table, parse_args

function check(sample_x::Float64, sample_y::Float64, radius::Float32)::Bool
    """
    Check if a sample is inside a given radius

    Args:
        sample_x: x coordinate
        sample_y: y coordinate
        radius: radius of the circle to check

    Returns:
        Whether or not the sample is inside the radius
    """
    # Check if sample is in the circle
    sample_radius = (sample_x ^ 2 + sample_y ^ 2)^0.5
    return sample_radius < radius
end

function integrate_quadrant(n_samples::Int, radius::Float32)::Tuple{Float64, Matrix{Float64}, Matrix{Float64}, Matrix{Float64}}
    """
    Integrates a quadrant of a circle to calculate pi

    Args:
        n_samples: number of samples
        radius: radius of the circle to consider

    Returns:
        success_ratio, samples, samples inside the circle, samples outside the circle
    """
    success = 0    
    samples = radius * rand(n_samples, 2) # 2D integration only
    samples_inside = []
    samples_outside = []

    for i in 1:n_samples
        checker = check(samples[i,1], samples[i,2], radius)
        if checker
            success = success + 1
            push!(samples_inside, samples[i,:])
        else
            push!(samples_outside, samples[i,:])
        end
    end
    return success / n_samples, samples, reduce(vcat, transpose.(samples_inside)), reduce(vcat, transpose.(samples_outside))
end

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--num_samples", "-n"
            help = "Number of samples"
            arg_type = Int
            default = 100
            required = true
        "--radius", "-r"
            help = "Radius of circle, used as a demo"
            arg_type = Float32
            default = 1.0
            required = false
        "--plot", "-p"
            help = "Output a plot"
            action = :store_true
    end

    return parse_args(s)
end

function main()
    # Allow user to specify number of samples
    args = parse_commandline()
    n_samples = args["num_samples"]
    r = args["radius"]

    quadrant, samples, samples_inside, samples_outside = integrate_quadrant(n_samples, r)
    pi_estimate = 4 * quadrant

    println("pi: $pi_estimate")

    if args["plot"]
        # Only plot if flag is passed
        p = plot(samples_inside[:,1], samples_inside[:,2], seriestype=:scatter, label="Samples: Inside", xlabel="X Coordinate", ylabel="Y Coordinate")
        plot!(samples_outside[:,1], samples_outside[:,2], seriestype=:scatter, label="Samples: Outside")

        savefig(p, "plot.png")
    end
end

main()