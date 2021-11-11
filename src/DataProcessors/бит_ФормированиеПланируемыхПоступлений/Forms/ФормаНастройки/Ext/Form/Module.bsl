﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Инициализация схемы компановки данных
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ИнициализироватьКомпоновщик(Объект.КомпоновщикНастроек);
	
	Если Параметры.Свойство("СтруктураНастроек") Тогда
		ОбработкаОбъект.РаспоковатьНастройкиИзСтруктурыМодуль(Объект, Параметры.СтруктураНастроек);
	КонецЕсли;
	
	МакетЦвета = Обработки.бит_ФормированиеПланируемыхПоступлений.ПолучитьМакет("МакетЛегенда");
	Цвета = МакетЦвета.ПолучитьТекст();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - действие команды "ОК".
// 
&НаКлиенте
Процедура КомандаОК(Команда)
	
	Результат = УпаковатьНастройкиВСтруктуру();
	
	Закрыть(Результат);
	
КонецПроцедуры

// Процедура - действие команды "ДействиеНастройкаПериода".
// 
&НаКлиенте
Процедура КомандаНастройкаПериода(Команда)
	
	ВыборПериода(Объект.Период);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура открывает форму выбора периода.
// 
// Параметры:
//  Период  - Стандартный период
// 
&НаКлиенте
Процедура ВыборПериода(Период)

	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Период;
	
	Оповещение = Новый ОписаниеОповещения("ПоказатьВыборПериода",ЭтаФорма);
	Диалог.Показать(Оповещение);
	 
КонецПроцедуры // ВыборПериода()

// Процедура выбора периода 
// 
&НаКлиенте 
Процедура ПоказатьВыборПериода(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
	
		Объект.Период = РезультатВыбора;
	
	КонецЕсли; 
	
КонецПроцедуры // ПоказатьВыборПериода

// Процедура сохраняет настройки формы в хранилища общих настроек.
// 
&НаСервере
Функция УпаковатьНастройкиВСтруктуру()
	
	ОбработкаОбъект = ДанныеФормыВЗначение(Объект, Тип("ОбработкаОбъект.бит_ФормированиеПланируемыхПоступлений"));
	СтруктураНастроек = ОбработкаОбъект.УпаковатьНастройкиВСтруктуруМодуль(Объект);
	
	Возврат СтруктураНастроек;
	
КонецФункции // СохранитьНастройки()

#КонецОбласти
