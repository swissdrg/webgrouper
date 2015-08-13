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
    pch[:pdx] = pc.pdx.to_s

    # TODO: possibly refactor to blank checks?
    pch[:diagnoses] = pc.diagnoses.map &:to_s
    pch[:procedures] = pc.procedures.map &:to_s

    return pch
  end

  def convert_result(result, pc)
    rh = Hash.new
    rh[:drg] = result.drg
    rh[:mdc] = result.mdc
    rh[:pccl] = result.pccl
    rh[:gst] = result.gst.to_s
    rh[:ageFlag] = convert_flag(pc.ageFlag)
    rh[:weightFlag] = convert_weight_flag(pc.admWeightFlag)
    rh[:sexFlag] = convert_flag(pc.sexFlag)
    rh[:admFlag] = convert_flag(pc.admFlag)
    rh[:sepFlag] = convert_flag(pc.sepFlag)
    rh[:losFlag] = convert_flag(pc.losFlag)
    # sdf flag does not exist anymore in the new grouper
    #rh[:sdfFlag] = convert_flag(pc.sdfFlag)
    rh[:hmvFlag] = convert_flag(pc.hmvFlag)
    # Contained in pdxDiagnosis flag below
    #rh[:pdxFlag] = convert_flag(pc.pdx)
    rh[:pdxDiagnosisFlag] = convert_diagnosis_flag(pc.pdx)
    i = -1
    rh[:diagnosesFlags] = pc.diagnoses.map{|d| convert_diagnosis_flag(d)}
    i = -1
    rh[:proceduresFlags] = pc.procedures.map{|d| convert_flag(d)}

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
    fh[:valid] = flag.valid
    fh[:used] = flag.used
    return fh
  end

  def convert_diagnosis_flag flag
    fh = Hash.new
    fh[:valid] = flag.valid
    fh[:used] = flag.used
    fh[:ccl] = flag.ccl
    return fh
  end

  def convert_ecw ecw
    { :effectiveCostWeight => ecw.effectiveCostWeight,
      :caseFlag => ecw.caseFlag.to_s }
  end

end