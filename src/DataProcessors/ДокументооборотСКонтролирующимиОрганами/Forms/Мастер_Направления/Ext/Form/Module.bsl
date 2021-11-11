﻿&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьПараметры(Параметры);
	Инициализация();
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПередЗакрытием_Завершение", 
		ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
		ОписаниеОповещения, 
		Отказ, 
		ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВывестиОшибку(Элемент)
	
	Если Элемент.Подсказка <> "" Тогда
		ПоказатьПредупреждение(,Элемент.Подсказка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияПроДоверенностьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	КонтекстЭДОКлиент.ОткрытьСписокДоверенностейИлиИнструкцию(
		НавигационнаяСсылкаФорматированнойСтроки, 
		СтандартнаяОбработка, 
		Организация);

КонецПроцедуры

&НаКлиенте
Процедура СдаватьВФНСПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	Если НЕ СдаватьВФНС Тогда 
		СдаватьВРосстат = Ложь;
	КонецЕсли;
	
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиФНСПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	Модифицированность = Истина;
	ОткрытьФормуНаправления("Добавить", "ПолучателиФНС");
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиФСГСПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	Модифицированность = Истина;
	ДобавитьНовоеНаправлениеФСГС();
	
КонецПроцедуры

&НаКлиенте
Процедура СдаватьВПФРПриИзменении(Элемент)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура СдаватьВФССПриИзменении(Элемент)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПодатьЗаявкуНаСертификатДляФСРАРПриИзменении(Элемент)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура СдаватьВРосстатПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	Если СдаватьВРосстат И НЕ СдаватьВФНС Тогда 
		СдаватьВФНС = Истина;
	КонецЕсли;
	
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#Область ФНС

&НаКлиенте
Процедура РедактироватьВыбранноеНаправлениеФНС()
	
	Если НЕ (СдаватьВФНС И ПризнакПоддержкиФНС) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.ПолучателиФНС.ТекущаяСтрока;
	
	Если КонтекстЭДОКлиент.ТекущаяСтрокаВыбрана(ПолучателиФНС,ТекущаяСтрока,"редактирования") Тогда

		ОткрытьФормуНаправления("Редактировать", "ПолучателиФНС");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиФНСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗапретитьИзменение Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Модифицированность = Истина;
	РедактироватьВыбранноеНаправлениеФНС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиФНСПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Модифицированность = Истина;
	РедактироватьВыбранноеНаправлениеФНС();
	
КонецПроцедуры

#КонецОбласти

#Область ФСГС

&НаКлиенте
Процедура ПолучателиФСГСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗапретитьИзменение Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	СтандартнаяОбработка = Ложь;
	РедактироватьВыбранноеНаправлениеФСГС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиФСГСПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Модифицированность = Истина;
	РедактироватьВыбранноеНаправлениеФСГС();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьВыбранноеНаправлениеФСГС()

	Если НЕ (СдаватьВРосстат И ПризнакПоддержкиРосстат) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.ПолучателиФСГС.ТекущаяСтрока;
	Если КонтекстЭДОКлиент.ТекущаяСтрокаВыбрана(ПолучателиФСГС, ТекущаяСтрока,"редактирования") Тогда

		ОписаниеОповещения = Новый ОписаниеОповещения("РедактированиеКодРосстатаЗавершение", ЭтотОбъект);
	
		КонтекстЭДОКлиент.КодРосстата(
			Элементы.ПолучателиФСГС.ТекущиеДанные.КодПолучателя, 
			Спецоператор, 
			ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура РедактированиеКодРосстатаЗавершение(ВыбранныйОрганТОГС, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйОрганТОГС <> Неопределено Тогда
		
		НовыеЗначенияПолучателя = Новый Структура("ТипПолучателя, КодПолучателя, КПП");
		НовыеЗначенияПолучателя.Вставить("ТипПолучателя",	ФСГС);
		НовыеЗначенияПолучателя.Вставить("КодПолучателя", 	ВыбранныйОрганТОГС.КодТОГС);
		
		ПредыдущиеЗначенияПолучателя = Новый Структура("ТипПолучателя, КодПолучателя, КПП");
		ПредыдущиеЗначенияПолучателя.Вставить("ТипПолучателя",	ФСГС);
		ПредыдущиеЗначенияПолучателя.Вставить("КодПолучателя", 	Элементы.ПолучателиФСГС.ТекущиеДанные.КодПолучателя);
		
		Если КонтекстЭДОКлиент.НаправлениеУникально(
				ПолучателиФСГС, 
				"Редактировать", 
				НовыеЗначенияПолучателя, 
				ПредыдущиеЗначенияПолучателя) Тогда
			
			ИдентификаторСтроки 		= Элементы.ПолучателиФСГС.ТекущаяСтрока;
			ТекущаяСтрока 				= ПолучателиФСГС.НайтиПоИдентификатору(ИдентификаторСтроки);
			ТекущаяСтрока.КодПолучателя = ВыбранныйОрганТОГС.КодТОГС;
			
			НаименованиеФСГС = КонтекстЭДОКлиент.НаименованиеТОГСаПоКоду(ВыбранныйОрганТОГС.КодТОГС, Спецоператор);
			ТекущаяСтрока.Наименование  = НаименованиеФСГС;
			
			Элементы.ПолучателиФСГС.Обновить();
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы
	
&НаКлиенте
Процедура Сохранить(Команда = Неопределено)
	
	УказаныКорректно = Истина;
	НаправленияУказаныКорректно(УказаныКорректно);
	
	Если УказаныКорректно Тогда
		
		Модифицированность = Ложь;
		
		Если ПризнакПоддержкиФСРАР И ПодатьЗаявкуНаСертификатДляФСРАР Тогда
			// Дополнительные вопросы
			УточнитьРегионФСРАРИЗатемЗакрыть();
		Иначе
			Результат = РезультатВыбораНаправлений();
			Закрыть(Результат);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытием_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Сохранить();
	
КонецПроцедуры

&НаСервере
Функция НаправленияУказаныКорректно(МастерДалее = Истина, ВыводитьСообщения = Истина)
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.НаправленияУказаныКорректно(ЭтотОбъект, МастерДалее, ВыводитьСообщения);

КонецФункции 

&НаКлиенте
Процедура УточнитьРегионФСРАРИЗатемЗакрыть()
	
	РегионЮрАдреса = РегламентированнаяОтчетностьКлиентСервер.РазложитьАдрес(АдресЮридическийЗначение).Регион;
	
	СхемаСдачиОтчетности = КонтекстЭДОКлиент.СхемаСдачиОтчетностиФСРАРпоКодуРегиона(РегионЮрАдреса);
	
	Если КодРегионаФСРАР <> РегионЮрАдреса И ЗначениеЗаполнено(РегионЮрАдреса)
		И СхемаСдачиОтчетности <> ПредопределенноеЗначение("Перечисление.СхемыСдачиОтчетностиФСРАР.СдачаВручную") Тогда
		
		НаименованиеРегионаЮрАдреса = НаименованиеСубъектаРФ(Число(РегионЮрАдреса));
		КодРегионаСНаименованием    = Формат(Число(РегионЮрАдреса), "ЧН=0; ЧГ=; ЧЦ=2; ЧВН=;") 
			+ ?(ЗначениеЗаполнено(НаименованиеРегионаЮрАдреса), " - ", "") + НаименованиеРегионаЮрАдреса;
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ВопросРегионЗаявкиРосалькогольрегулированияЗавершение", 
			ЭтотОбъект);
		
		ТекстВопроса = "Регион для Росалкогольрегулирования отличается от указанного в юридическом адресе:
			|" + КодРегионаСНаименованием + " 
			|
			|Продолжить?";
		
		ПоказатьВопрос(
			ОписаниеОповещения, 
			ТекстВопроса, 
			РежимДиалогаВопрос.ДаНет, 
			0, 
			КодВозвратаДиалога.Да);
			
		Возврат;
		
	Иначе
		
		ВопросРегионЗаявкиРосалькогольрегулированияЗавершение(КодВозвратаДиалога.Да, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НаименованиеСубъектаРФ(КодРегиона)
	
	Результат = "";
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	МакетКодыРегионов = КонтекстЭДОСервер.ПолучитьМакет("ФСРАРПорталыРегионов");
	
	НомерКолонкиКодРегиона = МакетКодыРегионов.Область("КодРегиона").Лево;
	НомерКолонкиНаименованиеРегиона = МакетКодыРегионов.Область("НаименованиеРегиона").Лево;
	ОбластьПоискаКодаРегиона = МакетКодыРегионов.Область(1, НомерКолонкиКодРегиона, МакетКодыРегионов.ВысотаТаблицы, НомерКолонкиКодРегиона);
	
	ОбластьСКодомРегиона = МакетКодыРегионов.НайтиТекст(Формат(Число(КодРегиона), "ЧН=0; ЧГ=; ЧЦ=2; ЧВН=;"), , ОбластьПоискаКодаРегиона, , Истина);
	
	Если ОбластьСКодомРегиона <> Неопределено Тогда
		Результат = МакетКодыРегионов.Область(ОбластьСКодомРегиона.Верх, НомерКолонкиНаименованиеРегиона, ОбластьСКодомРегиона.Верх, НомерКолонкиНаименованиеРегиона).Текст;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВопросРегионЗаявкиРосалькогольрегулированияЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Результат = РезультатВыбораНаправлений();
		Закрыть(Результат);
		
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНаправленияЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	КонтекстЭДОКлиент.ОткрытьФормуНаправленияЗавершение(
		ЭтотОбъект, 
		ПолучателиФНС,
		Результат, 
		ВходящийКонтекст);
		
КонецПроцедуры

&НаСервере
Функция РезультатВыбораНаправлений()
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	ДополнительныеПараметры = КонтекстЭДОСервер.ПараметрыФормыНаправлений(ЭтотОбъект);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораРегионовРФ()
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	МакетРегионов = КонтекстЭДОСервер.ПолучитьМакет("ФСРАРПорталыРегионов");
	
	Для НомСтр = 1 По МакетРегионов.ВысотаТаблицы Цикл
		
		ТекущийКодРегиона = СокрЛП(МакетРегионов.Область(НомСтр, 1, НомСтр, 1).Текст);
		НазваниеРегиона = СокрЛП(МакетРегионов.Область(НомСтр, 2, НомСтр, 2).Текст);
		
		Если ЗначениеЗаполнено(ТекущийКодРегиона) Тогда
			Элементы.КодРегионаФСРАР.СписокВыбора.Добавить(ТекущийКодРегиона, ТекущийКодРегиона + " - " + НазваниеРегиона);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметры(Параметры)
	
	ПараметрыФормы = Параметры.ПараметрыФормы;
	
	ТаблицаПолучателейФНС 	= ПолучитьИзВременногоХранилища(ПараметрыФормы.АдресПолучателейФНС);
	ЗначениеВРеквизитФормы(ТаблицаПолучателейФНС, "ПолучателиФНС");
	
	ТаблицаПолучателейФСГС 	= ПолучитьИзВременногоХранилища(ПараметрыФормы.АдресПолучателейФСГС);
	ЗначениеВРеквизитФормы(ТаблицаПолучателейФСГС, "ПолучателиФСГС");
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыФормы);
		
КонецПроцедуры
	
&НаСервере
Процедура Инициализация()
	
	ЗаполнитьСписокВыбораРегионовРФ();
	
	ФНС  = Перечисления.ТипыКонтролирующихОрганов.ФНС;
	ФСГС = Перечисления.ТипыКонтролирующихОрганов.ФСГС;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНаправления(Действие, ИмяТаблицыФормы)
	
	АдресПолучателей = АдресПолучателей(ИмяТаблицыФормы);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОткрытьФормуНаправления_Завершение", 
		ЭтотОбъект);
	
	КонтекстЭДОКлиент.ОткрытьФормуНаправления(
		ЭтотОбъект, 
		Действие, 
		ИмяТаблицыФормы, 
		ДанныеОрганизации, 
		Истина,
		АдресПолучателей,
		ОписаниеОповещения);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ОткрытьФормуНаправления_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНовоеНаправлениеФСГС()

	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавлениеКодРосстатаЗавершение", ЭтотОбъект);
	
	КонтекстЭДОКлиент.КодРосстата(
		Неопределено, 
		Спецоператор, 
		ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ДобавлениеКодРосстатаЗавершение(ВыбранныйОрганТОГС, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйОрганТОГС <> Неопределено Тогда
		
		НовыеЗначенияПолучателя = Новый Структура("ТипПолучателя, КодПолучателя, КПП");
		НовыеЗначенияПолучателя.Вставить("ТипПолучателя",	ФСГС);
		НовыеЗначенияПолучателя.Вставить("КодПолучателя", 	ВыбранныйОрганТОГС.КодТОГС);
		
		Если КонтекстЭДОКлиент.НаправлениеУникально(ПолучателиФСГС, "Добавить", НовыеЗначенияПолучателя) Тогда
		
			НоваяСтрока = ПолучателиФСГС.Добавить();
			НоваяСтрока.ТипПолучателя = ФСГС;
			НоваяСтрока.КодПолучателя = ВыбранныйОрганТОГС.КодТОГС;
			
			НаименованиеФСГС = КонтекстЭДОКлиент.НаименованиеТОГСаПоКоду(ВыбранныйОрганТОГС.КодТОГС, Спецоператор);
			НоваяСтрока.Наименование  = НаименованиеФСГС;
			
			Элементы.ПолучателиФСГС.Обновить();
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИзменитьОформлениеФормы();
	
КонецПроцедуры

&НаСервере
Функция АдресПолучателей(ИмяТаблицыФормы) Экспорт

	ТаблицаПолучателей = ЭтотОбъект[ИмяТаблицыФормы].Выгрузить();
	Возврат ПоместитьВоВременноеХранилище(ТаблицаПолучателей, Новый УникальныйИдентификатор);

КонецФункции

&НаСервере
Функция ИзменитьОформлениеФормы() Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	ИзменитьОформлениеФормы_ФНС();
	ИзменитьОформлениеФормы_Росстат();
	ИзменитьОформлениеФормы_ПФР();
	ИзменитьОформлениеФормы_ФСРАР();
	ИзменитьОформлениеФормы_Остальные();
	
	ВладелецЭПНеРуководитель = ВладелецЭЦПТип <> ПредопределенноеЗначение("Перечисление.ТипыВладельцевЭЦП.Руководитель");
	Если ВладелецЭПНеРуководитель Тогда
		
		СерыйЦвет = Новый Цвет(128, 128,128);
		
		ИнформацияПроДоверенность = ДокументооборотСКОКлиентСервер.ИзменитьОформлениеРекомендацииДоверенностиДляФНС(
			ВладелецЭЦПТип, 
			ЭтоЮридическоеЛицо, 
			ПолучателиФНС, 
			СерыйЦвет);
			
		ИнформацияПроДоверенность = Новый ФорматированнаяСтрока(
			Новый ФорматированнаяСтрока(НСтр("ru = 'Обратите внимание! '"),,СерыйЦвет),
			ИнформацияПроДоверенность);
			
		Элементы.ИнформацияПроДоверенность.Заголовок = ИнформацияПроДоверенность;
			
	КонецЕсли;
	
	Если ЗапретитьИзменение Тогда
		Элементы.ФормаСохранить.Видимость = Ложь;
		Элементы.ФормаЗакрыть.Видимость = Ложь;
	КонецЕсли;
	
	// Вывод ошибок
	РезультатПроверки = НаправленияУказаныКорректно(, Ложь);
	КонтекстЭДОСервер.ОтобразитьРезультатПроверкиРеквизитов(ЭтотОбъект, РезультатПроверки);
	
КонецФункции

&НаСервере
Функция ИзменитьОформлениеФормы_ФНС()
	
	// ФНС
	ВладелецЭПНеРуководитель = ВладелецЭЦПТип <> ПредопределенноеЗначение("Перечисление.ТипыВладельцевЭЦП.Руководитель");
	
	Включено = СдаватьВФНС И ПризнакПоддержкиФНС;
	
	Элементы.ГруппаФНС.ТолькоПросмотр 		= ЗапретитьИзменение;
	Элементы.ПолучателиФНС.ТолькоПросмотр 	= НЕ Включено;
	Элементы.ГруппаФНС.Видимость 			= ПризнакПоддержкиФНС;
	Элементы.ПолучателиФНСКПП.Видимость 	= ЭтоЮридическоеЛицо;
	Элементы.ГруппаИнформацияПроДоверенность.Доступность = Включено;
	Элементы.ГруппаИнформацияПроДоверенность.Видимость   = ВладелецЭПНеРуководитель;
	Элементы.ПолучателиФНС.АвтоОтметкаНезаполненного     = Включено;
	Если НЕ Включено Тогда
		Элементы.ПолучателиФНС.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ИзменитьОформлениеФормы_Росстат()
	
	// Росстат
	Включено = СдаватьВРосстат И ПризнакПоддержкиРосстат;
	
	Элементы.ГруппаРосстат.ТолькоПросмотр 	= ЗапретитьИзменение;
	Элементы.ПолучателиФСГС.ТолькоПросмотр 	= НЕ Включено;
	Элементы.ГруппаРосстат.Видимость 		= ПризнакПоддержкиРосстат;
	Элементы.ПолучателиФСГС.АвтоОтметкаНезаполненного = Включено;
	Если НЕ Включено Тогда
		Элементы.ПолучателиФСГС.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ИзменитьОформлениеФормы_ПФР()
	
	// ПФР
	Включено = СдаватьВПФР И ПризнакПоддержкиПФР;

	Элементы.ГруппаПФР.ТолькоПросмотр 	= ЗапретитьИзменение;
	Элементы.КодПФР.ТолькоПросмотр 		= НЕ Включено;
	Элементы.РегНомерПФР.ТолькоПросмотр = НЕ Включено;
	Элементы.ГруппаПФР.Видимость 		= ПризнакПоддержкиПФР;
	Элементы.КодПФР.АвтоОтметкаНезаполненного      = Включено;
	Элементы.РегНомерПФР.АвтоОтметкаНезаполненного = Включено;
	Если НЕ Включено Тогда
		Элементы.КодПФР.ОтметкаНезаполненного      = Ложь;
		Элементы.РегНомерПФР.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
	ЭтоИП = НЕ ЭтоЮридическоеЛицо;
	Если ЭтоИП Тогда
		
		Если ИПИспользуетТрудНаемныхРаботников Тогда
			Элементы.РегНомерПФР.Заголовок = НСтр("ru = 'Рег. номер в ПФР (за сотрудников)'");
		Иначе
			Элементы.РегНомерПФР.Заголовок = НСтр("ru = 'Рег. номер в ПФР (за себя)'");
		КонецЕсли;
		
	Иначе
		Элементы.РегНомерПФР.Заголовок = НСтр("ru = 'Рег. номер в ПФР'");
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ИзменитьОформлениеФормы_ФСРАР()
	
	// ФСРАР
	Включено = ПодатьЗаявкуНаСертификатДляФСРАР И ПризнакПоддержкиФСРАР;
	
	Элементы.ГруппаФСРАР.ТолькоПросмотр 			   = ЗапретитьИзменение;
	Элементы.ГруппаКодРегионаФСРАР.ТолькоПросмотр 	   = НЕ Включено;
	Элементы.ГруппаФСРАР.Видимость 					   = ПризнакПоддержкиФСРАР;
	Элементы.КодРегионаФСРАР.АвтоОтметкаНезаполненного = Включено;
	Если НЕ Включено Тогда
		Элементы.КодРегионаФСРАР.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ИзменитьОформлениеФормы_Остальные()
	
	// ФСС
	Элементы.ГруппаФСС.Видимость      = ПризнакПоддержкиФСС;
	Элементы.ГруппаФСС.ТолькоПросмотр = ЗапретитьИзменение;
	
	// РПН
	Элементы.ГруппаРПН.Видимость      = ПризнакПоддержкиРПН;
	Элементы.ГруппаРПН.ТолькоПросмотр = ЗапретитьИзменение;
	
	// ФТС
	Элементы.ГруппаФТС.Видимость 	  = ПризнакПоддержкиФТС;
	Элементы.ГруппаФТС.ТолькоПросмотр = ЗапретитьИзменение;
	
КонецФункции

&НаКлиенте
Процедура КодПФРПриИзменении(Элемент)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура РегНомерПФРПриИзменении(Элемент)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура КодРегионаФСРАРПриИзменении(Элемент)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиФНСПослеУдаления(Элемент)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиФСГСПослеУдаления(Элемент)
	Модифицированность = Истина;
	ИзменитьОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПодатьЗаявкуНаПодключениеРПНПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПодатьЗаявкуНаПодключениеФТСПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти