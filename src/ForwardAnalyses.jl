using Muscade
using StaticArrays
using LinearAlgebra
using MasterTask
using GLMakie

const 𝕣 = Float64

function ForwardAnalysis(cs_area, y_mod, mass, g, nNodes, tWidth, nHeight, type, scale; displayTower=false, saveTower=false)


    model           = Model(:TestModel) 

    println("BuildTower")

    Vₙ, Vₑ = BuildTower(model, nNodes, tWidth, nHeight, y_mod, cs_area, g, mass)
    println("GenerateExFs")

    Fᵁ = GenerateExFs(nNodes, type, scale) # Endre tittel

    println("ApplyExFs")
    Vₑᵁ  = ApplyExFs(model, nNodes, Vₙ, Fᵁ)

    println("initialize!")
    initialstate    = initialize!(model) # Initializes model


    println("solve")
    state           = solve(SweepX{0};initialstate,time=[0.,1.])

    #println("getdof")
    #tx1,_           = getdof(state,field=:tx1,nodID=[Vₙ[3]]) # Returns: dofresidual, dofID


    t = 2
    #println("ExtractMeasurements")
    δLᵥ = ExtractMeasurements(state, Vₑ,t)

    Vₑₓ = Vₑ[5:length(Vₑ)]
    #println("Typeof(forward state): ", typeof(state))
    #println("forward state[1]: ", state[1])
    ## GLMakie ##
    #println("Draw")

    println("Fᵁ: ", Fᵁ)
    Draw(state[1], "Forward analysis"; displayTower = displayTower, saveTower = saveTower)

    return state, δLᵥ, Vₑₓ
end 