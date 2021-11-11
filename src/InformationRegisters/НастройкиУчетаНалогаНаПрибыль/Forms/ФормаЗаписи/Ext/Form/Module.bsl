﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НастройкиУчетаНалогаНаПрибыльФормы.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	
	ПараметрыОповещения = Новый Структура("Организация, Период", НастройкиУчетаНалогаНаПрибыль.Организация, НастройкиУчетаНалогаНаПрибыль.Период);
	Оповестить("Запись_НастройкиУчетаНалогаНаПрибыль", ПараметрыОповещения);
	
	Оповестить("ИзменениеУчетнойПолитики", НастройкиУчетаНалогаНаПрибыль.Организация);
	ОповеститьОбИзменении(Тип("СправочникСсылка.ВидыНалоговИПлатежейВБюджет"));
	
	Если ПараметрыЗаписи.Свойство("РезультатВыполненияЗаданияКалендаряБухгалтера") Тогда
		КалендарьБухгалтераКлиент.ОжидатьЗавершениеЗаполненияВФоне(ПараметрыЗаписи.РезультатВыполненияЗаданияКалендаряБухгалтера);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РезультатВыполнения = КалендарьБухгалтера.ЗапуститьЗаполнениеВФоне(УникальныйИдентификатор, ТекущийОбъект.Организация);
	ПараметрыЗаписи.Вставить("РезультатВыполненияЗаданияКалендаряБухгалтера", РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НастройкиСистемыНалогообложения" Тогда
		
		ОрганизацияОповещения = Неопределено;
		Если Параметр.Свойство("Организация", ОрганизацияОповещения) И ОрганизацияОповещения = НастройкиУчетаНалогаНаПрибыль.Организация Тогда
			УправлениеФормой(ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПриИзмененииОрганизацииНаСервере();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеОбОшибкеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СистемаНалогообложения" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		НастройкиУчетаКлиент.ОбработкаНавигационнойСсылкиСистемаНалогообложения(
			ЭтотОбъект, НастройкиУчетаНалогаНаПрибыль.Организация, НастройкиУчетаНалогаНаПрибыль.Период);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	НастройкиУчетаНалогаНаПрибыль.Период = Дата(Период, 1, 1);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименяютсяРазныеСтавкиНалогаНаПрибыльПриИзменении(Элемент)
	
	НастройкиУчетаНалогаНаПрибыльФормыКлиент.ПоложенияПереходногоПериодаУСНПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокУплатыНалогаПриИзменении(Элемент)
	
	НастройкиУчетаНалогаНаПрибыль.УплачиватьНалогПоГруппамОбособленныхПодразделений = (ПорядокПодачиДекларации = 1);
	Элементы.НалоговыеОрганыГруппОбособленныхПодразделений.Доступность = НастройкиУчетаНалогаНаПрибыль.УплачиватьНалогПоГруппамОбособленныхПодразделений;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СтавкиНалогаНаПрибыльВБюджетСубъектовРФ(Команда)
	
	НастройкиУчетаНалогаНаПрибыльФормыКлиент.СтавкиНалогаНаПрибыльВБюджетСубъектовРФ(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатурныеГруппыРеализацииПродукцииУслуг(Команда)
	
	НастройкиУчетаНалогаНаПрибыльФормыКлиент.НоменклатурныеГруппыРеализацииПродукцииУслуг(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереченьПрямыхРасходов(Команда)
	
	НастройкиУчетаНалогаНаПрибыльФормыКлиент.ПереченьПрямыхРасходов(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговыеОрганыГруппОбособленныхПодразделений(Команда)
	
	УчетОбособленныхПодразделенийКлиент.НалоговыеОрганыГруппОбособленныхПодразделений(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	НастройкиУчета.ПодготовитьФормуНаСервере(ЭтотОбъект, НастройкиУчетаНалогаНаПрибыль);
	
	ЗаполнитьРеквизитыФормы();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормы()
	
	Период = Год(НастройкиУчетаНалогаНаПрибыль.Период);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Запись   = Форма.НастройкиУчетаНалогаНаПрибыль;
	
	Элементы.ПроверьтеНастройкиСистемыНалогообложения.Видимость = Не ПлательщикНалогаНаПрибыль(Запись.Организация, Запись.Период);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПлательщикНалогаНаПрибыль(Знач Организация, Знач Период)
	
	Возврат УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Период);
	
КонецФункции

&НаСервере
Процедура ПриИзмененииОрганизацииНаСервере() Экспорт
	
	ГоловнаяОрганизация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкиУчетаНалогаНаПрибыль.Организация, "ГоловнаяОрганизация");
	Элементы.ГруппаПорядокПодачиДекларации.Видимость = НалоговыйУчет.ЕстьОбособленныеПодразделения(ГоловнаяОрганизация);
	
КонецПроцедуры


#КонецОбласти
