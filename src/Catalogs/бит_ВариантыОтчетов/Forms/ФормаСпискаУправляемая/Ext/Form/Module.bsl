
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
  	// Стандартные действия при создании на сервере.
  	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОбновитьПредопределенныеВарианты(Команда)
	
	ОбновитьПредопределенныеВарианты();
	ТекстСообщения = Нстр("ru = 'Завершено обновление справочника ""Варианты отчетов"".'");
	бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.бит_ВариантыОтчетов"));
	
КонецПроцедуры // КомандаОбновитьПредопределенныеВарианты()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет предопределенные варианты отчетов.
// 
// Параметры:
//  Нет
// 
&НаСервере
Процедура ОбновитьПредопределенныеВарианты()
	
	бит_ОтчетыСервер.ОбновитьПредопределенныеВарианты();
		
КонецПроцедуры // ОбновитьПредопределенныеВарианты()

#КонецОбласти

