﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		 	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	МетаданныеОбъекта = Метаданные.Документы.бит_ЗаявкаНаРасходованиеСредств;
	
	бит_РаботаСДиалогамиСервер.ФормаВыбораПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

	// Добавление кнопки "Раскрасить по статусам"
	// Также добавляются процедуры: К-Подключаемый_РаскраситьПоСтатусам(), С-ОформитьСписокДокументовПоСтатусам().
	бит_РаботаСДиалогамиСервер.ДобавитьКнопкуРаскраситьПоСтатусам(Элементы, Команды, КоманднаяПанель,
																  МетаданныеОбъекта);
	ОформитьСписокДокументовПоСтатусам(Элементы.РаскраситьПоСтатусам.Пометка, Истина);
	
	// +СБ. Широков Николай. 2014-09-04. 
	ИжТиСи_СВД_Сервер.ОК_ВывестиРеквизиты(ЭтаФорма, "Документ.бит_ЗаявкаНаРасходованиеСредств.ФормаВыбораУправляемая");
	// -СБ. Широков Николай 	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемыОбработчикиКоманд

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

// Процедура назначается динамически действию кнопки командной панели 
// КоманднаяПанель.РаскраситьПоСтатусам
// (обработчик события "Нажатие" кнопки "РаскраситьПоСтатусам").
//
&НаКлиенте
Процедура Подключаемый_РаскраситьПоСтатусам()
	
	Элементы.РаскраситьПоСтатусам.Пометка = Не Элементы.РаскраситьПоСтатусам.Пометка;
	ОформитьСписокДокументовПоСтатусам(Элементы.РаскраситьПоСтатусам.Пометка);	
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет оформление списка документов по статусам
//
// Параметры:
//  ТолькоОчистить - Булево.
// 
&НаСервере
Процедура ОформитьСписокДокументовПоСтатусам(ПометкаКн, ЭтоОткрытие = Ложь)

	Если ЭтоОткрытие И Не ПометкаКн Тогда
		Возврат;	
	КонецЕсли;
	
	МетаданныеОбъекта = Метаданные.Документы.бит_ЗаявкаНаРасходованиеСредств;
	
	МасОбъектов = ?(ПометкаКн, бит_РаботаСДиалогамиСервер.ПолучитьМассивОбъектов(МетаданныеОбъекта), Новый Массив);
	бит_РаботаСДиалогамиСервер.ОформитьСписокДокументовПоСтатусам(МасОбъектов, ПометкаКн, ЭтаФорма.УсловноеОформление);
	
	Если Не ЭтоОткрытие Тогда
		// Сохранение значения пометки.
		РегистрыСведений.бит_СохраненныеЗначения.СохранитьЗнч(бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
																	,МетаданныеОбъекта
																	,"РаскраситьПоСтатусам_Пометка"
																	,ПометкаКн);
	КонецЕсли;
																
КонецПроцедуры

#КонецОбласти
