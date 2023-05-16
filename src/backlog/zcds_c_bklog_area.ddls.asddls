@AbapCatalog.sqlViewName: 'ZCDSTBKLOGAREA02'
@AbapCatalog.compiler.compareFilter: true
@EndUserText.label: 'BKLOG: Area de Desarrollo'
@ObjectModel.semanticKey: 'AREA_KEY'
@ObjectModel.transactionalProcessingDelegated: true
@ObjectModel.createEnabled:true
@ObjectModel.deleteEnabled:true
@ObjectModel.updateEnabled:true
@VDM.viewType: #CONSUMPTION
@UI: {
  headerInfo: {
    typeName: 'Area',
    typeNamePlural: 'Areas',
    title: { type: #STANDARD, value: 'Area de Desarrollo' }
  }
}

@OData.publish: true



define view ZCDS_C_BKLOG_AREA
  as select from ZCDS_I_BKLOG_AREA as _Area
{
  @UI.lineItem.position: 10
  @UI.lineItem: [{label: 'UUID de Area'}]
  @UI.selectionField: {position: 10 }
  @UI.identification: {position: 10, importance: #MEDIUM,label: 'UUID de Area' }
  key _Area.area_key,
  @UI.lineItem.position: 20
  @UI.lineItem: [{label: 'ID de Area'}]
  @UI.selectionField: {position: 20 }
  @UI.identification: {position: 20, importance: #HIGH,label: 'ID de Área' }
  _Area.area_id,
  @UI.lineItem.position: 30
  @UI.lineItem: [{label: 'Descripción'}]
  @UI.identification: {position: 30, importance: #HIGH,label: 'Descripción' }
  @UI.selectionField: {position: 30 }
  _Area.area_desc,
  @UI.lineItem.position: 40
  @UI.identification: {position: 40, importance: #HIGH,label: 'Creado el' }
  @UI.selectionField: {position: 40 }
  _Area.erdat,
  @UI.lineItem.position: 50
  @UI.identification: {position: 50, importance: #HIGH,label: 'Hora Creación' }
  @UI.selectionField: {position: 50 }
  _Area.erzeit,
  @UI.lineItem.position: 60
  @UI.identification: {position: 60, importance: #HIGH,label: 'Creado Por' }
  @UI.selectionField: {position: 60 }
  _Area.ernam,
  @UI.lineItem.position: 70
  @UI.identification: {position: 70, importance: #HIGH }
  @UI.selectionField: {position: 70 }
  _Area.moddate,
  @UI.lineItem.position: 80
  @UI.identification: {position: 80, importance: #HIGH }
  @UI.selectionField: {position: 80 }
  _Area.modtime,
  @UI.lineItem.position: 90
  @UI.identification: {position: 90, importance: #HIGH }
  @UI.selectionField: {position: 90 }
  _Area.modnam
}
