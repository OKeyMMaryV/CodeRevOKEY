﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.НадписьЛогина.Заголовок = НСтр("ru = 'Логин:'") + " " + Параметры.login;
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаИнформации.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Подключение1СТакскомКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ПрограммноеЗакрытие Тогда
		
		Если ЭтотОбъект.Модифицированность И Не ЗавершениеРаботы Тогда
			
			Отказ = Истина;
			ТекстВопроса = НСтр("ru = 'Данные изменены. Закрыть форму без сохранения данных?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("ПриОтветеНаВопросОЗакрытииМодифицированнойФормы",
				ЭтотОбъект);
			
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		Иначе
			
			Подключение1СТакскомКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьВыходНажатие(Элемент)
	
	Подключение1СТакскомКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияТехПоддержкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения =
			НСтр("ru = 'У меня не получается ввести уникальный идентификатор участника ЭД вручную.
				|
				|Прошу помочь разобраться с проблемой.
				|
				|%1'");
		
		ЛогинПользователя = Подключение1СТакскомКлиент.ЗначениеСессионногоПараметра(
			КонтекстВзаимодействия.КСКонтекст,
			"login");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения,
			Подключение1СТакскомКлиент.ТекстТехническихПараметровЭДО(КонтекстВзаимодействия));
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			НСтр("ru = '1С-Такском. Ввод уникального идентификатора участника обмена ЭД вручную.'"),
			ТекстСообщения,
			"taxcom",
			,
			Новый Структура("Логин, Пароль",
				ЛогинПользователя,
				Подключение1СТакскомКлиент.ЗначениеСессионногоПараметра(
					КонтекстВзаимодействия.КСКонтекст,
					"password")));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если НЕ ПустаяСтрока(УникальныйИдентификаторУчастникаОбмена) Тогда
		
		Оповестить("ОповещениеОПолученииУникальногоИдентификатораУчастникаОбменаЭД",
			УникальныйИдентификаторУчастникаОбмена);
		
		ЭтотОбъект.Модифицированность = Ложь;
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОтветеНаВопросОЗакрытииМодифицированнойФормы(РезультатВопроса, ДопПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
