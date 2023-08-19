@EndUserText.label: 'Consumption view for PL attachment'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_PL_ATTACH as projection on ZI_PL_ATTACH
{
    key Plist,
    key AttachNo,
    Attachment,
    Mimetype,
    Filename,
    LastChangedAt,
    /* Associations */
    _Head : redirected to parent ZC_PL_HEAD_TP
}
