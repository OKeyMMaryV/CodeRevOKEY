﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоступныеПредметы.Загрузить(Параметры.ДоступныеПредметы.Выгрузить());
	Элементы.Предмет.СписокВыбора.ЗагрузитьЗначения(ДоступныеПредметы.Выгрузить( , "Предмет").ВыгрузитьКолонку("Предмет"));
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторПользователя = Пользователи.ТекущийПользователь().ИдентификаторПользователяСервиса;
	
	СинонимКонфигурации = Метаданные.Синоним;
	НайденныйЭлемент = Элементы.Предмет.СписокВыбора.НайтиПоЗначению(СинонимКонфигурации);
	Если НайденныйЭлемент = Неопределено Тогда
		ПозицияЗапятой = СтрНайти(СинонимКонфигурации, ",");
		Если ПозицияЗапятой > 0 Тогда
			НайденныйЭлемент = Элементы.Предмет.СписокВыбора.НайтиПоЗначению(Лев(СинонимКонфигурации, ПозицияЗапятой - 1));
		КонецЕсли;
	КонецЕсли;
	Если НайденныйЭлемент = Неопределено Тогда 
		Предмет = Элементы.Предмет.СписокВыбора.Получить(0).Значение;
	Иначе
		Предмет = НайденныйЭлемент.Значение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьИдею(Команда)
	
	Если ПустаяСтрока(Наименование) Тогда 
		ВызватьИсключение НСтр("ru = 'Поле Наименование не должно быть пустым'");
	КонецЕсли;
	
	Если ПустаяСтрока(Предмет) Тогда 
		ВызватьИсключение НСтр("ru = 'Поле Предмет не должно быть пустым'");
	КонецЕсли;
	
	ДобавитьИдеюСервер();
	Закрыть();
	Оповестить("НоваяИдея");
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Идея добавлена'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьИдеюСервер()
	
	WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиЦентраИдей();
	
	ТекстHTML = "";
	Вложения = Новый Структура;
	Содержание.ПолучитьHTML(ТекстHTML, Вложения);
    Обработки.ИнформационныйЦентр.ДобавитьИнформациюОПриложении(ТекстHTML, Новый Структура);
	ПриведенныйСписокВложений = ПривестиСписокВложений(Вложения, WSПрокси.ФабрикаXDTO);
	
	Попытка
		WSПрокси.addIdea(Строка(ИдентификаторПользователя), ТекстHTML, ПриведенныйСписокВложений, Предмет, Наименование);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации(), 
		                         УровеньЖурналаРегистрации.Ошибка,
		                         ,
		                         ,ТекстОшибки);
		ТекстВывода = ИнформационныйЦентрСервер.ТекстВыводаИнформацииОбОшибкеВЦентреИдей();
		ВызватьИсключение ТекстВывода;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ПривестиСписокВложений(Знач СписокВложений, Знач ФабрикаXDTOВебСервиса)
	
	ТипСпискаВложений    = ФабрикаXDTOВебСервиса.Тип("http://www.1c.ru/1cFresh/InformationCenter/UsersIdeas/1.0.0.1", "AttachmentList");
	ТипСтруктурыВложения = ФабрикаXDTOВебСервиса.Тип("http://www.1c.ru/1cFresh/InformationCenter/UsersIdeas/1.0.0.1", "Attachment");
	
	СписокОбъектовВложений = ФабрикаXDTOВебСервиса.Создать(ТипСпискаВложений);
	
	Если СписокВложений.Количество() = 0 Тогда 
		Возврат СписокОбъектовВложений;
	КонецЕсли;
	
	Для Каждого Вложение Из СписокВложений Цикл
		
		СтруктураВложения = ФабрикаXDTOВебСервиса.Создать(ТипСтруктурыВложения);
		СтруктураВложения.Name = Вложение.Ключ;
		СтруктураВложения.Data  = Вложение.Значение.ПолучитьДвоичныеДанные();
		
		Обработки.ИнформационныйЦентр.ДобавитьЗначениеВСписокXDTO(СписокОбъектовВложений, "AttachmentElement" , СтруктураВложения);
		
	КонецЦикла;
	
	Возврат СписокОбъектовВложений;
	
КонецФункции

#КонецОбласти


