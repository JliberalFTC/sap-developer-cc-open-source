@AbapCatalog.sqlViewName: 'ZCDSTBKLOGAREA01'
@AbapCatalog.compiler.compareFilter: true
@EndUserText.label: 'BKLOG: Area de Desarrollo'

@ObjectModel.modelCategory:#BUSINESS_OBJECT
@ObjectModel.semanticKey: 'AREA_KEY'
@ObjectModel.representativeKey: 'AREA_KEY'
@ObjectModel.compositionRoot:true
@ObjectModel.transactionalProcessingEnabled:true
@ObjectModel.writeActivePersistence:'ZCA_BKLOG_AREA'
@ObjectModel.createEnabled:true
@ObjectModel.deleteEnabled:true
@ObjectModel.updateEnabled:true

@VDM.viewType: #TRANSACTIONAL
define view ZCDS_I_BKLOG_AREA
  as select from zca_bklog_area as _Area
{
      @ObjectModel.text.element:['area_key']
      @ObjectModel.readOnly: true
  key _Area.area_key,
      @Search.defaultSearchElement: true
      @ObjectModel.mandatory: true
      _Area.area_id,
      @Semantics.text:true
      @ObjectModel.mandatory: true
      _Area.area_desc,
      @ObjectModel.readOnly: true
      @Semantics.systemDate.createdAt: true
      _Area.erdat,
      @ObjectModel.readOnly: true
      @Semantics.systemTime.createdAt: true
      _Area.erzeit,
      @ObjectModel.readOnly: true
      @Semantics.user.createdBy: true
      _Area.ernam,
      @ObjectModel.readOnly: true
      @Semantics.systemDate.lastChangedAt: true
      _Area.moddate,
      @ObjectModel.readOnly: true
      @Semantics.systemTime.lastChangedAt: true
      _Area.modtime,
      @ObjectModel.readOnly: true
      @Semantics.user.lastChangedBy: true
      _Area.modnam
}
