////////////////////////////////////////////////////////////////////////////////
// Модуль содержит интерфейсы к методам типовых конфигураций.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область УправлениеВзаиморасчетами

// Функция получает договор контрагента по умолчанию с учетом условий отбора. 
// Возвращается основной договор или единственный или пустая ссылка.
// 
Функция УстановитьДоговорКонтрагента(ДоговорКонтрагента, ВладелецДоговора, ОрганизацияДоговора, СписокВидовДоговора = Неопределено, СтруктураПараметров = Неопределено) Экспорт
	
	флВыполнено = Ложь;
	
	Если бит_ОбщегоНазначения.ЭтоСемействоБП() Тогда	
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("РаботаСДоговорамиКонтрагентовБП");
		флВыполнено = Модуль.УстановитьДоговорКонтрагента(ДоговорКонтрагента, ВладелецДоговора, ОрганизацияДоговора, СписокВидовДоговора, СтруктураПараметров);                
		
	ИначеЕсли бит_ОбщегоНазначения.ЭтоУТ() Тогда
		
		// Нет аналогов
		
    ИначеЕсли бит_ОбщегоНазначения.ЭтоСемействоERP() Тогда	
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("БухгалтерскийУчетПереопределяемый");
		флВыполнено = Модуль.УстановитьДоговорКонтрагента(ДоговорКонтрагента, ВладелецДоговора, ОрганизацияДоговора, СписокВидовДоговора, СтруктураПараметров);                
		
	КонецЕсли;
    
    Если НЕ флВыполнено И ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ДоговорКонтрагента = ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
	КонецЕсли;
	
	Возврат флВыполнено;
	
КонецФункции // УстановитьДоговорКонтрагента()	

// Устанавливает банковский счет по умолчанию. Возвращает состояние установлен/не установлен.
// 
Функция УстановитьБанковскийСчет(Счет, ВладелецСчета, Валюта, СовпадениеВалюты = Истина) Экспорт
	
	// ++ БП 
	Возврат УчетДенежныхСредствБП.УстановитьБанковскийСчет(Счет, ВладелецСчета, Валюта, СовпадениеВалюты);
	// -- БП 
	
КонецФункции

#КонецОбласти

#КонецОбласти
