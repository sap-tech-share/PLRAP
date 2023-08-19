@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for ZPL_TAB_HEAD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PL_HEAD as select from ztab_pl_head
association[1] to I_UnitOfMeasure as _UnitOfMeasure on $projection.Unit = _UnitOfMeasure.UnitOfMeasure
{
    key plist as Plist,
    name as Name,
    plate_no as PlateNo,
    est_chg_req as EstChgReq,
    @Semantics.quantity.unitOfMeasure: 'Unit'
    qty as Qty,
    unit as Unit,
    division as Division,
    owner as Owner,
    zzuser as Zzuser,
    year_of_const as YearOfConst,
    exp_date as ExpDate,
    km_reading as KmReading,
    act_config as ActConfig,
    equip_con_code as EquipConCode,
    alloc_code as AllocCode,
    equip_type as EquipType,
    description as Description,
    diso as Diso,
    diso_options as DisoOptions,
    log_catg as LogCatg,
    comments as Comments,
    ref_file as RefFile,
    attachmnt as Attachmnt,
    status as Status,
    apprv_by as ApprovedBy,
    proc_file_no as ProcFileNo,
    contract_no as ContractNo,
    procurement_dt as ProcurementDate,
    delivery_dt as DeliveryDate,
    
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    changed_by as ChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    changed_at as ChangedAt,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    locl_changed_at as LoclChangedAt,
    
    _UnitOfMeasure._Text[Language = $session.system_language].UnitOfMeasureName as UnitName,
    _UnitOfMeasure
}
