﻿#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функция для работы со сканером.

// Устарела. Следует использовать РаботаСФайламиКлиент.ОткрытьФормуНастройкиСканирования();
// Открывает форму настройки сканирования.
Процедура ОткрытьФормуНастройкиСканирования() Экспорт
	
	РаботаСФайламиКлиент.ОткрытьФормуНастройкиСканирования();
	
КонецПроцедуры

// Сохраняет подпись на диск
Процедура СохранитьПодпись(АдресПодписи) Экспорт
	
	Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
		Возврат;
	КонецЕсли;
		
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Фильтр = НСтр("ru = 'Все файлы(*.p7s)|*.p7s'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файл для сохранения подписи'");
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		ПолныйПутьПодписи = ДиалогОткрытияФайла.ПолноеИмяФайла;
		
		Файл = Новый Файл(ПолныйПутьПодписи);
		ПередаваемыеФайлы = Новый Массив;
		Описание = Новый ОписаниеПередаваемогоФайла(ПолныйПутьПодписи, АдресПодписи);
		ПередаваемыеФайлы.Добавить(Описание);
		
		ПутьКФайлу = Файл.Путь;
		Если Прав(ПутьКФайлу,1) <> "\" Тогда
			ПутьКФайлу = ПутьКФайлу + "\";
		КонецЕсли;
		
		// Сохраним Файл из БД на диск
		ПолучитьФайлы(ПередаваемыеФайлы,, ПутьКФайлу, Ложь);
			
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Подпись сохранена в файл ""%1""'"),
			ДиалогОткрытияФайла.ПолноеИмяФайла);
		Состояние(Текст);
		
	КонецЕсли;
	
КонецПроцедуры

// Проинициализировать параметр сеанса ПутьКРабочемуКаталогуПользователя, проверив корректность пути, и откорректировав если нужно
// 
Процедура ПроинициализироватьПутьКРабочемуКаталогу() Экспорт
	
	ИмяКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьРабочийКаталогПользователя();
	
	// уже проинициализировано
	//izhtc-Kir 31.08.2015 (
	//Если ИмяКаталога <> Неопределено И НЕ ПустаяСтрока(ИмяКаталога) И ПроверкаДоступаКРабочемуКаталогуВыполнена = Истина Тогда
	//	Возврат;
	//КонецЕсли;
	//izhtc-Kir 31.08.2015 )
	
	Если ИмяКаталога = Неопределено Тогда
		ИмяКаталога = ПолучитьПутьККаталогуДанныхПользователя();
		Если Не ПустаяСтрока(ИмяКаталога) Тогда
			СохранитьПутьККаталогуВНастройках(ИмяКаталога);
		Иначе
			ПроверкаДоступаКРабочемуКаталогуВыполнена = Истина;
			Возврат; //  веб клиент без расширения работы с файлами
		КонецЕсли;
	КонецЕсли;
	
#Если Не ВебКлиент Тогда
	// Создать каталог для файлов
	Попытка
		СоздатьКаталог(ИмяКаталога);
		ИмяКаталогаТестовое = ИмяКаталога + "ПроверкаДоступа\";
		СоздатьКаталог(ИмяКаталогаТестовое);
		УдалитьФайлы(ИмяКаталогаТестовое);
	Исключение
		// нет прав на создание каталога, или такой путь отсутствует - сбрасываем в настройки по умолчанию
		ИмяКаталога = ПолучитьПутьККаталогуДанныхПользователя();
		СохранитьПутьККаталогуВНастройках(ИмяКаталога);
	КонецПопытки;
#КонецЕсли
	
	ПроверкаДоступаКРабочемуКаталогуВыполнена = Истина;
	
КонецПроцедуры

// Функция получает путь к каталогу вида "C:\Documents and Settings\ИМЯ ПОЛЬЗОВАТЕЛЯ\Application Data\1C\ФайлыА8\"
//
Функция ПолучитьПутьККаталогуДанныхПользователя() Экспорт
	
	ИмяКаталога = "";
	
#Если Не ВебКлиент Тогда
	
	Если НЕ СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
		Оболочка = Новый COMОбъект("WScript.Shell");
		Путь = Оболочка.ExpandEnvironmentStrings("%APPDATA%");
		Путь = Путь + "\1C\Файлы\";
		Путь = Путь + ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ИмяКонфигурации + "\";
		
		ИмяПользователя = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ТекущийПользователь;
		ИмяКаталога = Путь + ИмяПользователя;
		ИмяКаталога = СтрЗаменить(ИмяКаталога, "<", " ");
		ИмяКаталога = СтрЗаменить(ИмяКаталога, ">", " ");
		ИмяКаталога = СокрЛП(ИмяКаталога);
		ИмяКаталога = ИмяКаталога + "\";
	КонецЕсли;
	
#Иначе // ВебКлиент
	
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	
	Если РасширениеПодключено Тогда
		
		Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.Каталог = "";
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь к локальному кэшу файлов'");
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			ИмяКаталога = ДиалогОткрытияФайла.Каталог;
			ИмяКаталога = ИмяКаталога + "\";
		КонецЕсли;
		
	КонецЕсли;
	
#КонецЕсли
	
	Возврат ИмяКаталога;

КонецФункции

// Сохраняет путь к рабочему каталогу в настройках
//
Процедура СохранитьПутьККаталогуВНастройках(ИмяКаталога)
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("ЛокальныйКэшФайлов", "ПутьКЛокальномуКэшуФайлов", ИмяКаталога);
	
КонецПроцедуры

// открыть Windows проводник, выбрав в нем указанный файл
//
Функция ОткрытьПроводникСФайлом(Знач ПолноеИмяФайла) Экспорт
	
#Если НЕ ВебКлиент Тогда
	ФайлНаДиске = Новый Файл(ПолноеИмяФайла);
	
	Если ФайлНаДиске.Существует() Тогда
		
		Если Лев(ПолноеИмяФайла, 0) <> """" Тогда
			ПолноеИмяФайла = """" + ПолноеИмяФайла + """";
		КонецЕсли;
		
		ЗапуститьПриложение("explorer.exe /select, " + ПолноеИмяФайла);
		
		Возврат Истина;
		
	КонецЕсли;
#КонецЕсли
	
	Возврат Ложь;
	
КонецФункции
    
//izhtc-Kir 31.08.2015 (

// Получает представление поля КомуВыдан или КемВыдан сертификата ЭЦП
//
// Параметры
//  СтруктураПользователя  - Структура - структура поля КомуВыдан или КемВыдан сертификата
// Возвращаемое значение - Строка - представление
//
// Возвращаемое значение:
//   Строка  - представление
Функция ПолучитьПредставлениеПользователя(СтруктураПользователя) Экспорт
	Перем SN, GN, T, CN, O, OU;
	
	Если СтруктураПользователя.Свойство("SN", SN) Тогда
		// Усиленный сертификат - чтение ФИО из тегов SN и G.
		СтруктураПользователя.Свойство("GN", GN);
		СтруктураПользователя.Свойство("T", T);
		СтруктураПользователя.Свойство("CN", CN);
		СтруктураПользователя.Свойство("OU", OU);
		
		Представление = Строка(SN);
		Если ЗначениеЗаполнено(GN) Тогда
			Представление = Представление + " " + GN;
		КонецЕсли;
		Если ЗначениеЗаполнено(T) Тогда
			Представление = Представление + ", " + T;
		КонецЕсли;
		Если ЗначениеЗаполнено(CN) Тогда
			Представление = Представление + ", " + CN;
		КонецЕсли;
		Если ЗначениеЗаполнено(OU) Тогда
			Представление = Представление + ", " + OU;
		КонецЕсли;
	Иначе
		// Чтение ФИО из тега CN.
		СтруктураПользователя.Свойство("CN", CN);
		СтруктураПользователя.Свойство("O", O);
		СтруктураПользователя.Свойство("OU", OU);
		
		Представление = Строка(CN);
		Если ЗначениеЗаполнено(O) И O <> CN Тогда
			Представление = Представление + ", " + O;
		КонецЕсли;
		Если ЗначениеЗаполнено(OU) Тогда
			Представление = Представление + ", " + OU;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции
//izhtc-Kir 31.08.2015 )

 // Рекурсивно обойти каталоги и посчитать количество файлов и их суммарный размер
//
Процедура ОбходФайловРазмер(Путь, МассивФайлов, РазмерСуммарный, КоличествоСуммарное) Экспорт
	
	Для Каждого ВыбранныйФайл Из МассивФайлов Цикл
		
		Если ВыбранныйФайл.ЭтоКаталог() Тогда
			НовыйПуть = Строка(Путь);
			НовыйПуть = НовыйПуть + "\";
			НовыйПуть = НовыйПуть + Строка(ВыбранныйФайл.Имя);
			МассивФайловВКаталоге = НайтиФайлы(НовыйПуть, "*.*");
			
			Если МассивФайловВКаталоге.Количество() <> 0 Тогда
				ОбходФайловРазмер(НовыйПуть, МассивФайловВКаталоге, РазмерСуммарный, КоличествоСуммарное);
			КонецЕсли;
		
			Продолжить;
		КонецЕсли;
		
		РазмерСуммарный = РазмерСуммарный + ВыбранныйФайл.Размер();
		КоличествоСуммарное = КоличествоСуммарное + 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
