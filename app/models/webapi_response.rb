class WebapiResponse
  def initialize(result, pc, effective_cost_weight, system_id)
    @result = { :PatientCase => convert_patientcase(pc),
                :GrouperResult => convert_result(result, pc), :SystemId => system_id,
                :EffectiveCostWeight => convert_ecw(effective_cost_weight) }
  end

  def result
    @result
  end

  def convert_patientcase pc
    pch = Hash.new
    pch[:id] = pc.id
    pch[:entryDate] = pc.entryDate
    pch[:exitDate] = pc.exitDate
    pch[:birthDate] = pc.birthDate
    pch[:leaveDays] = pc.leaveDays
    pch[:ageYears] = pc.ageYears
    pch[:ageDays] = pc.ageDays
    pch[:admWeight] = pc.admWeight
    pch[:sex] = pc.sex
    pch[:adm] = pc.adm
    pch[:sep] = pc.sep
    pch[:los] = pc.los
    pch[:hmv] = pc.hmv
    pch[:pdx] = pc.pdx

    # TODO: possibly refactor to blank checks?
    pch[:diagnoses] = pc.diagnoses.select {|e| e != nil}# && !"".eql?(e)}
    pch[:procedures] = pc.procedures.select {|e| e != nil}# && !"".eql?(e)}

    return pch
  end

  def convert_result(result, pc)
    rh = Hash.new
    rh[:drg] = result.drg
    rh[:mdc] = result.mdc
    rh[:pccl] = result.pccl
    rh[:gst] = result.gst.to_s
    rh[:ageFlag] = convert_flag(result.ageFlag)
    rh[:weightFlag] = convert_weight_flag(result.admWeightFlag)
    rh[:sexFlag] = convert_flag(result.sexFlag)
    rh[:admFlag] = convert_flag(result.admFlag)
    rh[:sepFlag] = convert_flag(result.sepFlag)
    rh[:losFlag] = convert_flag(result.losFlag)
    rh[:sdfFlag] = convert_flag(result.sdfFlag)
    rh[:hmvFlag] = convert_flag(result.hmvFlag)
    rh[:pdxFlag] = result.pdxFlag.to_s
    rh[:pdxDiagnosisFlag] = convert_diagnosis_flag(result.pdxDiagnosisFlag)
    i = -1
    rh[:diagnosesFlags] = result.diagnosesFlags.select{|d|i = i + 1; d!= nil && pc.diagnoses[i] != nil}.
        map{|d| convert_diagnosis_flag(d)}
    i = -1
    rh[:proceduresFlags] = result.proceduresFlags.select{|d|i = i + 1; d!= nil && pc.procedures[i] != nil}.
        map{|d| convert_procedure_flag(d)}

    return rh
  end

  def convert_flag flag
    fh = Hash.new
    fh[:valid] = flag.valid
    fh[:used] = flag.used
    return fh
  end

  def convert_weight_flag flag
    fh = Hash.new
    fh[:valid] = flag.valid.to_s
    fh[:used] = flag.used.to_s
    return fh
  end

  def convert_procedure_flag flag
    fh = convert_weight_flag flag
    fh[:por] = flag.por.to_s
    return fh
  end

  def convert_diagnosis_flag flag
    fh = Hash.new
    fh[:valid] = flag.valid.to_s
    fh[:used] = flag.used
    fh[:ccl] = flag.ccl
    return fh
  end

  def convert_ecw ecw
    { :effectiveCostWeight => ecw.effectiveCostWeight,
      :caseFlag => ecw.caseFlag.to_s }
  end

end