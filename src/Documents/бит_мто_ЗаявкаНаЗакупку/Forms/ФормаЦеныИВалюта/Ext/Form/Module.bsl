
#Область ОбработчикиСобытийФормы
	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТипЦен") Тогда
		ТипЦен = Параметры.ТипЦен;
	КонецЕсли;
	
	Если Параметры.Свойство("ВалютаДокумента") Тогда
		ВалютаДокумента = Параметры.ВалютаДокумента;
	КонецЕсли;
	
	Если Параметры.Свойство("КратностьДокумента") Тогда
		КратностьДокумента = Параметры.КратностьДокумента;
	КонецЕсли;
	
	Если Параметры.Свойство("КурсДокумента") Тогда
		КурсДокумента = Параметры.КурсДокумента;
	КонецЕсли;
	
	Если Параметры.Свойство("СуммаВключаетНДС") Тогда
		СуммаВключаетНДС = Параметры.СуммаВключаетНДС;
	КонецЕсли;
	
	Если Параметры.Свойство("ДатаДокумента") Тогда
		ДатаДокумента = Параметры.ДатаДокумента;
	КонецЕсли;
	
	ВариантРасчетаНДС = ?(СуммаВключаетНДС, Перечисления.ВариантыРасчетаНДС.НДСВСумме, Перечисления.ВариантыРасчетаНДС.НДССверху);
			
	СписокВыбораВариантовРасчетаНДС = Элементы.ВариантРасчетаНДС.СписокВыбора;
	СписокВыбораВариантовРасчетаНДС.Добавить(Перечисления.ВариантыРасчетаНДС.НДСВСумме);
	СписокВыбораВариантовРасчетаНДС.Добавить(Перечисления.ВариантыРасчетаНДС.НДССверху);
			
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события при изменении "ТипЦен".
// 
&НаКлиенте
Процедура ТипЦенПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ТипЦен) Тогда
		ЦенаВключаетНДС = ОпределитьЦенаВключаетНДС(ТипЦен, "ЦенаВключаетНДС");
		
		Если ЦенаВключаетНДС Тогда
			ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДСВСумме");
			СуммаВключаетНДС 	= Истина;
		Иначе
			ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДССверху");
			СуммаВключаетНДС 	= Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события при изменении "ВалютаДокумента".
// 
&НаКлиенте
Процедура ВалютаДокументаПриИзменении(Элемент)
	
	ИзменениеВалютыСервер();
	
КонецПроцедуры

// Процедура - обработчик события при изменении "ВариантРасчетаНДС".
// 
&НаКлиенте
Процедура ВариантРасчетаНДСПриИзменении(Элемент)
	
	Если ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДСВСумме") Тогда 
		СуммаВключаетНДС 	= Истина;
	Иначе
		СуммаВключаетНДС 	= Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПересчитатьИЗакрыть(Команда)
	
	Если Не ЗначениеЗаполнено(ВариантРасчетаНДС) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнен вариант расчета НДС!'");
		Поле = "ВариантРасчетаНДС";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Поле);
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнена валюта!'");
		Поле = "ВалютаДокумента";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Поле);
		Возврат;
	КонецЕсли;	
	
	СтруктураРеквизитовФормы = Новый Структура;
	СтруктураРеквизитовФормы.Вставить("ТипЦен",               ТипЦен);
	СтруктураРеквизитовФормы.Вставить("ВалютаДокумента",      ВалютаДокумента);
	СтруктураРеквизитовФормы.Вставить("КратностьДокумента",   КратностьДокумента);
	СтруктураРеквизитовФормы.Вставить("КурсДокумента",        КурсДокумента);
	СтруктураРеквизитовФормы.Вставить("СуммаВключаетНДС",     СуммаВключаетНДС);
	СтруктураРеквизитовФормы.Вставить("ВариантРасчетаНДС",	  ВариантРасчетаНДС);
	
	Закрыть(СтруктураРеквизитовФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция определяет значение "ЦенаВключаетНДС".
// 
&НаСервере
Функция ОпределитьЦенаВключаетНДС(ТипЦен, Реквизит)

	Возврат ТипЦен[Реквизит];
	
КонецФункции // ОпределитьЦенаВключаетНДС()

// Процедура изменение валюты.
// 
&НаСервере
Процедура ИзменениеВалютыСервер()

	СтрКурса = бит_КурсыВалют.ПолучитьКурсВалюты(ВалютаДокумента,ДатаДокумента);
	КурсДокумента      = СтрКурса.Курс;
	КратностьДокумента = СтрКурса.Кратность;

КонецПроцедуры // ИзменениеВалютыМодуль()

#КонецОбласти 
