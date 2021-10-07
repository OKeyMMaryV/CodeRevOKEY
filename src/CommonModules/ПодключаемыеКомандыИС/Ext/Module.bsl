﻿#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииКомандПодключенныхКОбъекту(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды) Экспорт 
	
	ДоступныеКоманды = ПодключаемыеКомандыИСКлиентСервер.КомандыОбъекта(НастройкиФормы.ИмяФормы);
	Если ДоступныеКоманды.ОформитьИС.Количество()
		Или ДоступныеКоманды.ВыбратьИС.Количество() Тогда
	
		ШаблонКоманды = ШаблонКоманды(ИнтеграцияИС.ОписаниеТиповПоПолномуИмени(НастройкиФормы.ИмяФормы));
		ДополнитьКомандыИзДоступных(Команды, ДоступныеКоманды, ШаблонКоманды);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОпределенииВидовПодключаемыхКоманд(ВидыПодключаемыхКоманд) Экспорт
	
	Для Каждого ВидКомандИС Из ПодключаемыеКомандыИСКлиентСервер.ВидыПодключаемыхКоманд() Цикл
		
		Вид = ВидыПодключаемыхКоманд.Добавить();
		ЗаполнитьЗначенияСвойств(Вид,ВидКомандИС);
		Вид.ВидГруппыФормы = ВидГруппыФормы.Подменю;
		Вид.Картинка       = Новый Картинка;
		Вид.Отображение    = ОтображениеКнопки.Текст;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма) Экспорт
	
#Область ОпределениеКомандДляУправленияВидимостью
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма,"ВидимостьПодключаемыхКоманд") = Ложь Тогда 
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ВидимостьПодключаемыхКоманд",Новый ОписаниеТипов));
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		Форма.ВидимостьПодключаемыхКоманд = Новый Структура;
	КонецЕсли;
#КонецОбласти
	
#Область ДоработкаПослеБСП
	Для Каждого ВидКомандИС Из ПодключаемыеКомандыИСКлиентСервер.ВидыПодключаемыхКоманд() Цикл
		Если Форма.Элементы[ВидКомандИС.ИмяПодменю].Вид = ВидГруппыФормы.ГруппаКнопок Тогда
			Форма.Элементы[ВидКомандИС.ИмяПодменю].Вид = ВидГруппыФормы.Подменю;
			Форма.Элементы[ВидКомандИС.ИмяПодменю].ОтображениеФигуры = ОтображениеФигурыКнопки.Нет;
		КонецЕсли;
	КонецЦикла;
#КонецОбласти
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДополнитьКомандыИзДоступных(Команды, ДоступныеКоманды, ШаблонКоманды)
	
	Для Каждого ВидКомандИС Из ПодключаемыеКомандыИСКлиентСервер.ВидыПодключаемыхКоманд() Цикл
		
		НомерПоПорядку = 1;
		ШаблонКоманды.Вставить("Вид",        ВидКомандИС.Имя);
		ШаблонКоманды.Вставить("Обработчик", ВидКомандИС.Обработчик);
		
		Для Каждого КомандаИС Из ДоступныеКоманды[ВидКомандИС.Имя] Цикл 
			
			Если ЕстьПравоДоступа(ВидКомандИС.Имя,ВидКомандИС.ТипМетаданных,КомандаИС.ИмяМетаданных) Тогда 
				Команда = Команды.Добавить();
				ЗаполнитьЗначенияСвойств(Команда, ШаблонКоманды);
				ЗаполнитьЗначенияСвойств(Команда, КомандаИС);
				Команда.Идентификатор = ВидКомандИС.Имя + КомандаИС.ИмяМетаданных;
				Команда.Порядок = НомерПоПорядку;
			КонецЕсли;
			НомерПоПорядку = НомерПоПорядку + 1;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЕстьПравоДоступа(ВидКоманды,ТипМетаданных,ИмяМетаданных) 
	
	Если ВидКоманды = "ОформитьИС" Тогда
		ИмяПраваДоступа = "Добавление";
	ИначеЕсли ВидКоманды = "ВыбратьИС" Тогда 
		ИмяПраваДоступа = "Просмотр";
	КонецЕсли;
	
	Возврат ПравоДоступа(ИмяПраваДоступа,Метаданные[ТипМетаданных][ИмяМетаданных]);
	
КонецФункции

Функция ШаблонКоманды(ОписаниеТипов)
	
	Результат = Новый Структура;
	Результат.Вставить("ТипПараметра",             ОписаниеТипов);
	Результат.Вставить("Назначение",               "ДляОбъекта");
	Результат.Вставить("ИзменяетВыбранныеОбъекты", Истина);
	Результат.Вставить("РежимЗаписи",              "Проводить");
	Возврат Результат;
	
КонецФункции

#КонецОбласти