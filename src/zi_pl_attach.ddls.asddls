@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Procurement List Attachment'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PL_ATTACH as select from ztab_pl_attach
association to parent ZI_PL_HEAD_TP as _Head on $projection.Plist = _Head.Plist
{
    key plist as Plist,
    key attach_no as AttachNo,
    @Semantics.largeObject: {
        fileName: 'Filename',
        mimeType: 'Mimetype',
        contentDispositionPreference: #INLINE
    }
    attachment as Attachment,
    
    @Semantics.mimeType: true
    mimetype as Mimetype,
    filename as Filename,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    
    _Head
}
