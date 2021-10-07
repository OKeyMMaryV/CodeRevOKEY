﻿////////////////////////////////////////////////////////////////////////////////
//
// Серверные процедуры и функции регламентированных отчетов ФСРАР общего назначения 
// с кешируемым результатом на время вызова.
//  
////////////////////////////////////////////////////////////////////////////////

Функция ОбработкаСохраненияАдресаКонтрагента(Контрагент = Неопределено, 
												ПолеСтруктурыАдреса,  
												ДатаАдреса = Неопределено,
												ПроверятьАдрес = Истина) Экспорт
												
	Представление = Неопределено;
	СтруктураАдреса = Неопределено;
	
	Если ЗначениеЗаполнено(Контрагент) И (НЕ ЗначениеЗаполнено(ПолеСтруктурыАдреса)) Тогда
		// Пустое поле - значит надо определить по контрагенту.
		СписокВидовКонтактнойИнформации = Новый СписокЗначений;
		СписокВидовКонтактнойИнформации.Добавить("ЮрАдресКонтрагента");
		СписокВидовКонтактнойИнформации.Добавить("ФактАдресКонтрагента");
		СписокВидовКонтактнойИнформации.Добавить("ПочтовыйАдресКонтрагента");
		СписокВидовКонтактнойИнформации.Добавить("ЮрАдресОрганизации");
		СписокВидовКонтактнойИнформации.Добавить("АдресПоПропискеФизическиеЛица");
		СписокВидовКонтактнойИнформации.Добавить("АдресМестаПроживанияФизическиеЛица");
		
		ПолеСтруктурыАдреса = РегламентированнаяОтчетностьАЛКО.АдресОбъектаВСтрокуСтруктурыХранения(
										Контрагент, 
										Представление, 
										СписокВидовКонтактнойИнформации, 
										Истина, 
										ДатаАдреса, ,
										ПроверятьАдрес);									
	КонецЕсли;
	
	РегламентированнаяОтчетностьАЛКО.ОбработкаСохраненияАдреса(
								ПолеСтруктурыАдреса, 
								Представление, 
								СтруктураАдреса, 
								ПроверятьАдрес);
								
	Результат = Новый Структура;
	Результат.Вставить("ПолеСтруктурыАдреса", 	ПолеСтруктурыАдреса);
	Результат.Вставить("Представление", 		Представление);
	Результат.Вставить("СтруктураАдреса", 		СтруктураАдреса);
	
	Возврат Результат;
	
КонецФункции

Функция СтруктураАдресаИзСтрокиСтруктурыХранения(ПолеСтруктурыАдреса) Экспорт

	Если НЕ ТипЗнч(ПолеСтруктурыАдреса) = Тип("Строка") Тогда
		ПолеСтруктурыАдреса = "";	
	КонецЕсли;
	
	ПолеСтруктурыАдреса = СокрЛП(ПолеСтруктурыАдреса);
	
	Если ЗначениеЗаполнено(ПолеСтруктурыАдреса) Тогда
	
		ВариантСтрокиАдреса = РегламентированнаяОтчетностьАЛКО.ВариантКонтактнойИнформацииАЛКО(ПолеСтруктурыАдреса);
		
		Если ВариантСтрокиАдреса.ЭтоСтруктураАдреса Тогда
		
			Префикс = РегламентированнаяОтчетностьАЛКО.ПрефиксСтрокиСтруктурыХраненияАдреса();
			ДлинаПрефикса = СтрДлина(Префикс);
			
			СтрокаВнутрСтруктурыАдреса = Сред(ПолеСтруктурыАдреса, ДлинаПрефикса + 1);
			
			СтруктураАдреса = ЗначениеИзСтрокиВнутр(СтрокаВнутрСтруктурыАдреса);
			
		ИначеЕсли ВариантСтрокиАдреса.ЭтоXML ИЛИ ВариантСтрокиАдреса.ЭтоJSON Тогда
			
			СтруктураАдреса = РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруАдресаИзСтандартногоПредставленияИлиXMLИлиJSON(
										ПолеСтруктурыАдреса, Истина);
		Иначе
			ПолеСтруктурыАдреса = "";
			СтруктураАдреса = РегламентированнаяОтчетностьАЛКО.ПолучитьПустуюСтруктуруАдреса();
		КонецЕсли; 
		
	Иначе
		СтруктураАдреса = РегламентированнаяОтчетностьАЛКО.ПолучитьПустуюСтруктуруАдреса();
	КонецЕсли; 

	Возврат СтруктураАдреса;
	
КонецФункции
