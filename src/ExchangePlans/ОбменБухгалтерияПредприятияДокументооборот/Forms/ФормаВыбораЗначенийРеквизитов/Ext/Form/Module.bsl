﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТипОбъекта = Параметры.ТипОбъекта;
	ВидДокумента = Параметры.ВидДокумента;
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ТипОбъекта);
	МассивСкрываемыхРеквизитов = СкрываемыеРеквизиты(ТипОбъекта);
	Для каждого Реквизит из ОбъектМетаданных.Реквизиты Цикл
		Если Лев(ВРег(Реквизит.Имя), 7) = "УДАЛИТЬ" Тогда
			Продолжить;
		КонецЕсли;
		Если МассивСкрываемыхРеквизитов.Найти(Реквизит.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СтрокаРеквизита = ЗначенияРеквизитов.Добавить();
		СтрокаРеквизита.ИмяРеквизита = Реквизит.Имя;
		СтрокаРеквизита.ПредставлениеРеквизита = ?(ЗначениеЗаполнено(Реквизит.Синоним),
			Реквизит.Синоним,
			Реквизит.Имя);
		СтрокаРеквизита.ОписаниеТипов = Реквизит.Тип;
		ЗначениеРеквизита = Неопределено;
		Если ТипЗнч(Параметры.ЗначенияРеквизитов) = Тип("Структура") Тогда
			Если Не Параметры.ЗначенияРеквизитов.Свойство(Реквизит.Имя, ЗначениеРеквизита) Тогда
				СтрокаРеквизита.ЗначениеРеквизита = Неопределено;
			Иначе
				СтрокаРеквизита.ЗначениеРеквизита = Реквизит.Тип.ПривестиЗначение(ЗначениеРеквизита);
				СтрокаРеквизита.ПорядокСортировки = 1;
			КонецЕсли;
		КонецЕсли;
		СтрокаРеквизита.ОтметкаНезаполненного = 
			СтрокаРеквизита.ИмяРеквизита = "ВидДоговора"
			И Не ЗначениеЗаполнено(СтрокаРеквизита.ЗначениеРеквизита);
	КонецЦикла;
	ЗначенияРеквизитов.Сортировать("ПорядокСортировки УБЫВ, ПредставлениеРеквизита");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Результат = Новый Структура;
	Для каждого Строка из ЗначенияРеквизитов Цикл
		Если ЗначениеЗаполнено(Строка.ЗначениеРеквизита) Тогда
			Результат.Вставить(Строка.ИмяРеквизита, Строка.ЗначениеРеквизита);
		КонецЕсли;
	КонецЦикла;
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗначенияРеквизитовПередНачаломИзменения(Элемент, Отказ)
	
	Если Элементы.ЗначенияРеквизитов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПолеВвода = Элементы.ЗначенияРеквизитовЗначениеРеквизита;
	ПолеВвода.ОграничениеТипа = Элементы.ЗначенияРеквизитов.ТекущиеДанные.ОписаниеТипов;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияРеквизитовЗначениеРеквизитаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЗначенияРеквизитов.ТекущиеДанные;
	ТекущиеДанные.ОтметкаНезаполненного = 
		ТекущиеДанные.ИмяРеквизита = "ВидДоговора"
		И Не ЗначениеЗаполнено(ТекущиеДанные.ЗначениеРеквизита);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СкрываемыеРеквизиты(ТипОбъекта)
	
	Реквизиты = Новый Массив;
	Если ТипОбъекта = "Справочник.ДоговорыКонтрагентов" Тогда
		Реквизиты.Добавить("Владелец");
		Реквизиты.Добавить("Организация");
		Реквизиты.Добавить("Дата");
		Реквизиты.Добавить("Номер");
		Реквизиты.Добавить("ВалютаВзаиморасчетов");
		Реквизиты.Добавить("Наименование");
		Реквизиты.Добавить("СрокДействия");
	ИначеЕсли ТипОбъекта = "Документ.ПлатежноеПоручение" Тогда
		Реквизиты.Добавить("ВидПлатежа");
		Реквизиты.Добавить("Контрагент");
		Реквизиты.Добавить("ДоговорКонтрагента");
		Реквизиты.Добавить("ИННПлательщика");
		Реквизиты.Добавить("ИННПолучателя");
		Реквизиты.Добавить("КПППлательщика");
		Реквизиты.Добавить("КПППолучателя");
		Реквизиты.Добавить("ТекстПлательщика");
		Реквизиты.Добавить("ТекстПолучателя");
		Реквизиты.Добавить("ДокументОснование");
		Реквизиты.Добавить("Организация");
		Реквизиты.Добавить("Дата");
		Реквизиты.Добавить("НазначениеПлатежа");
		Реквизиты.Добавить("ВалютаДокумента");
		Реквизиты.Добавить("СуммаДокумента");
		Реквизиты.Добавить("СуммаНДС");
		Реквизиты.Добавить("СтавкаНДС");
		Реквизиты.Добавить("СчетОрганизации");
		Реквизиты.Добавить("СчетКонтрагента");
	КонецЕсли;
	Возврат Реквизиты;
	
КонецФункции

#КонецОбласти