﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Инициализация схемы компановки данных.
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		
	ОбработкаОбъект.ИнициализироватьКомпоновщик(Объект.КомпоновщикНастроек);
	
	Если Параметры.Свойство("СтруктураНастроек") Тогда
		ОбработкаОбъект.РаспоковатьНастройкиИзСтруктурыМодуль(Объект, Параметры.СтруктураНастроек);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаПериода(Команда)
	
	ВыборПериода(Объект.Период);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Результат = УпаковатьНастройкиВСтруктуру();
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура открывает форму выбора периода.
// 
// Параметры:
//  Период  - Стандартный период.
// 
&НаКлиенте
Процедура ВыборПериода(Период)

	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Период;
	
	Оповещение = Новый ОписаниеОповещения("ВыборПериодаЗавершение",ЭтаФорма);
	Диалог.Показать(Оповещение);
	 
КонецПроцедуры

&НаКлиенте 
Процедура ВыборПериодаЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
	
		Объект.Период = РезультатВыбора;
	
	КонецЕсли; 
	
КонецПроцедуры

// Процедура сохраняет настройки формы в хранилища общих настроек.
// 
&НаСервере
Функция УпаковатьНастройкиВСтруктуру()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	СтруктураНастроек = ОбработкаОбъект.УпаковатьНастройкиВСтруктуруМодуль(Объект);
	
	Возврат СтруктураНастроек;
	
КонецФункции

#КонецОбласти
