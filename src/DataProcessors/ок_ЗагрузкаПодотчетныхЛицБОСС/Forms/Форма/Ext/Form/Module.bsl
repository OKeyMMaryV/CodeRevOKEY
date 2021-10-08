﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ок_Организация") Тогда
		Объект.Организация = Параметры.ок_Организация;
	КонецЕсли;
	
	Элементы.ПринудительнаяЗагрузка.Видимость	=	Пользователи.ЭтоПолноправныйПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ФизЛицаБОССВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка	=	Ложь;
	
	ТекущиеДанные	=	Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	Если Поле.Имя = "ФизЛицаБОССФизическоеЛицо" И ЗначениеЗаполнено(ТекущиеДанные.ФизическоеЛицо) Тогда
		ПоказатьЗначение(, ТекущиеДанные.ФизическоеЛицо);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиВБОСС(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ЗаполнитьТаблицуФизЛицНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВЕИС(Команда)
	
	Если Объект.ФизЛицаБОСС.Количество() = 0 Тогда
		Возврат;	
	КонецЕсли;
	
	Если Элементы.ФизЛицаБОСС.ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, "Не выделено ни одной строки для загрузки в ЕИС!", 10, "Загрузка физ. лиц в ЕИС");
		Возврат;	
	КонецЕсли;
	
	ОписаниеОповещения	=	Новый ОписаниеОповещения("ЗагрузитьВЕИСЗавершение", ЭтаФорма);
	
	ПоказатьВопрос(ОписаниеОповещения, "Загрузить выделенные строки в ЕИС?", РежимДиалогаВопрос.ДаНет, 10, 
		КодВозвратаДиалога.Нет, "Загрузка физ. лиц в ЕИС", КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьВЕИСЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
	
		МассивКодовБОСС = Новый Массив;
		Для Каждого ИдентификаторСтроки Из Элементы.ФизЛицаБОСС.ВыделенныеСтроки Цикл
			Строка  =  Объект.ФизЛицаБОСС.НайтиПоИдентификатору(ИдентификаторСтроки);
			Если Не Строка = Неопределено Тогда
				МассивКодовБОСС.Добавить(Строка.КодБОСС);
			КонецЕсли;
		КонецЦикла;
		ЗагрузитьВЕИСНаСервере(МассивКодовБОСС);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуФизЛицНаСервере()
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("Организация", Объект.Организация);
	Если ЗначениеЗаполнено(Объект.Фамилия) Тогда
		ПараметрыПоиска.Вставить("Фамилия", Объект.Фамилия);
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Имя) Тогда
		ПараметрыПоиска.Вставить("Имя", Объект.Имя);
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Отчество) Тогда
		ПараметрыПоиска.Вставить("Отчество", Объект.Отчество);
	КонецЕсли;
	
	ТабФизЛица = ок_БОСС_ЗагрузкаДанныхПодотчетники.НайтиФизЛицаВБОСС(ПараметрыПоиска);	
	Объект.ФизЛицаБОСС.Загрузить(ТабФизЛица);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВЕИСНаСервере(МассивКодовБОСС)
	
	СоответствиеКодовБОССИФизЛиц = ок_БОСС_ЗагрузкаДанныхПодотчетники.ЗагрузитьФизЛицаИзБОСС(
										МассивКодовБОСС, Объект.Организация, ПринудительнаяЗагрузка);
	Для Каждого Элемент Из СоответствиеКодовБОССИФизЛиц Цикл
		СтрокиСКодомБОСС = Объект.ФизЛицаБОСС.НайтиСтроки(Новый Структура("КодБОСС", Элемент.Ключ));
		Для Каждого СтрокаСКодомБОСС Из СтрокиСКодомБОСС Цикл
			СтрокаСКодомБОСС.ФизическоеЛицо = Элемент.Значение;
		КонецЦикла;
	КонецЦикла;  
	
КонецПроцедуры

#КонецОбласти


