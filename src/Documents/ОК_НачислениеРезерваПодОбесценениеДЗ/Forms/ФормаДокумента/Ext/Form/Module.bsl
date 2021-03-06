&НаКлиенте
Процедура СчетаУчетаРасчетовНажатие(Элемент, СтандартнаяОбработка)
	       
	ФормаСпискаСчетов = ПолучитьФорму("Документ.ОК_НачислениеРезерваПодОбесценениеДЗ.Форма.ФормаСпискаСчетов");
	Счета = Счета();
	ФормаСпискаСчетов.ОграниченныйСписок	= Счета;
	ФормаСпискаСчетов.СписокИспользуемых	= СписокИспользумеых;
	Результат = ФормаСпискаСчетов.ОткрытьМодально();
	СписокИспользумеых = Результат;
	
КонецПроцедуры

&НаСервере
Функция Счета()
	
	ОграниченныйСписок	= Новый СписокЗначений;
	ОграниченныйСписок.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАвансамВыданным);
	ОграниченныйСписок.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПокупателями);
	ОграниченныйСписок.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоПретензиям);
	ОграниченныйСписок.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСРозничнымиПокупателями);
	ОграниченныйСписок.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПоставщикамиИПодрядчиками);
	ОграниченныйСписок.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПокупателямиИЗаказчиками);
	ОграниченныйСписок.Добавить(ПланыСчетов.Хозрасчетный.ПрочиеРасчетыСРазнымиДебиторамиИКредиторами);  
	
	Возврат ОграниченныйСписок;
	
КонецФункции

// + СБ Прудникова 2011-12-21
&НаСервере
Процедура ДобавитьКнопкиПодменю()
	
	ОбработчикЗаполнениеРСБУ ="ЗаполнитьДанныеПоУчету";
	ОбработчикЗаполнениеРегистр ="ЗаполнитьДанныеПоРегистру";
	//БИТ_Егоров+
	ОбработчикЗаполнениеКорректировкаРезерва ="ЗаполнитьЗакладкуКорректировкаРезерва";
	//БИТ_Егоров-
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьКнопокПодменю()
	
	ОрганизацияОКЕЙ = Справочники.Организации.НайтиПоКоду("000000045");
	ОрганизацияДоринда = Справочники.Организации.НайтиПоКоду("000000001");
	
	КнопкаЗаполнить = Элементы.Найти("Заполнить");
	Если НЕ КнопкаЗаполнить = Неопределено Тогда
		КнопкаДействия = Элементы.Найти("ДанныеЗаполнитьДанныеПоУчету");
		Доступность1 = Объект.Организация = ОрганизацияДоринда;
		Если НЕ КнопкаДействия = Неопределено Тогда
			КнопкаДействия.Доступность = Доступность1;
		КонецЕсли;
		
		КнопкаДействия = Элементы.Найти("ДанныеЗаполнитьДанныеПоРегистру");
		КнопкаДействияКР = Элементы.Найти("ДанныеЗаполнитьЗакладкуКорректировкаРезерва"); //БИТ_Егоров
		Доступность2 = Объект.Организация = ОрганизацияОКЕЙ;
		Если НЕ КнопкаДействия = Неопределено Тогда
			КнопкаДействия.Доступность = Доступность2;
			КнопкаДействияКР.Доступность = Доступность2;   //БИТ_Егоров
		КонецЕсли;
	КонецЕсли;
	
	//БИТ_Егоров+
	БИТ_УтановитьВидимостьТЧ_БИТ_КорректировкаРезерва();
    //БИТ_Егоров-

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьДоступностьКнопокПодменю();
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДанныеПоРегистру_Сервер()
	
	ТаблицаРезультата = ЗаполнитьДанныеПоРегиструДебиторскаяЗадолженность_Вызов_Функции(); 

	Объект.Данные.Загрузить(ТаблицаРезультата);

	//БИТ_Егоров+
	Если ТаблицаРезультата.Итог("ПроверкаВалютыОтличнойОтРубля")>0 Тогда
		Элементы.Данные.ПодчиненныеЭлементы.Валюта.Видимость = Истина;
		Элементы.Данные.ПодчиненныеЭлементы.ВалютнаяСумма.Видимость = Истина;
	КонецЕсли;
КонецФункции


&НаКлиенте
Процедура ЗаполнитьДанныеПоРегистру(Команда) 
	
	Если Объект.Данные.Количество()>0 Тогда
		Ответ = Вопрос("Перед заполнением табличная часть ""Данные"" будет очищена. Продолжить?",РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Возврат;
		КонецЕсли;
		
		Объект.Данные.Очистить();
	КонецЕсли;
	
	ЗаполнитьДанныеПоРегистру_Сервер();
	//БИТ_Егоров-
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеПоУчету(Команда) 
	//+СБ ПискуноваВ 06.06.2016  #2366
	Если Объект.Данные.Количество()>0 Тогда
		Ответ = Вопрос("Перед заполнением табличная часть ""Данные"" будет очищена. Продолжить?",РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Возврат;
		КонецЕсли; 		
		Объект.Данные.Очистить();
	КонецЕсли;
	//-СБ Пискунова В 06.06.2016  #2366   
	
	ЗаполнитьДанные_Вызов_Функции();
КонецПроцедуры

&НаСервере
Функция ЗаполнитьЗакладкуКорректировкаРезерва_Сервер()

	Объект.БИТ_КорректировкаРезерва.Загрузить(БИТ_ЗаполнитьКорректировкуРезерва_Вызов_Функции());
	
	БИТ_УтановитьВидимостьТЧ_БИТ_КорректировкаРезерва();
	
КонецФункции


//БИТ_Егоров+
&НаКлиенте
Процедура ЗаполнитьЗакладкуКорректировкаРезерва(Команда)
	
	Если ИнтеграцияС1СДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "Проведен") Тогда
		Ответ = Вопрос("Необходимо отменить проведение документа. Продолжить?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		Иначе
			ПараметрыЗаписи = Новый Структура;
			ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения);
			ЗаписатьДокумент_Сервер(ПараметрыЗаписи);
			
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.БИТ_КорректировкаРезерва.Количество()> 0 Тогда
		Ответ = Вопрос("Табличная часть не пустая. Очистить?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		Иначе
			Объект.БИТ_КорректировкаРезерва.Очистить();
		КонецЕсли;
	КонецЕсли;

	ЗаполнитьЗакладкуКорректировкаРезерва_Сервер();
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьДокумент_Сервер(ПараметрыЗаписи)
	ЭтотОбъект.Записать(ПараметрыЗаписи);
КонецФункции

&НаСервере
Процедура БИТ_УтановитьВидимостьТЧ_БИТ_КорректировкаРезерва()
	ОрганизацияОКЕЙ = Справочники.Организации.НайтиПоКоду("000000045");
	Если Не ОрганизацияОКЕЙ = Объект.Организация Тогда
		Объект.БИТ_КорректировкаРезерва.Очистить();
	КонецЕсли;
	
	Если Объект.БИТ_КорректировкаРезерва.Количество() > 0 Тогда
		Элементы.КорректировкаРезерва.Видимость = Истина;
	Иначе
		Элементы.КорректировкаРезерва.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры
//БИТ_Егоров-

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	   	
	ОбновитьДаты();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДаты()
	Объект.Дата = КонецМесяца(Объект.Дата);
	//ОК+ Аверьянова 01.07.14 #832# 
	Объект.ДатаСторно = КонецМесяца(Объект.Дата) + 1;
	//ОК- Аверьянова 01.07.14 #832#
    Объект.Период=рс_ОбщийМодуль.ПолучитьМесяцНачисленияПоДате(Объект.Дата);
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеСчетовНажатие(Элемент, СтандартнаяОбработка)
	
	ФормаСоответствия = ПолучитьФорму("РегистрСведений.бит_СоответствияАналитик.ФормаСписка");
	ФормаСоответствия.ВидСоответствия = ПредопределенноеЗначение("Справочник.бит_ВидыСоответствийАналитик.СчетРСБУ_СчетМСФО");
	ФормаСоответствия.ОткрытьМодально();
		
КонецПроцедуры



/// СБ Прудникова 2011-12-21

&НаКлиенте
Процедура ДанныеПриИзмененииФлажка(Элемент)
	//+СБ ПИскунова В 09.06.2016 #2366 Требования изменились
	
	////ТекСтрНачислятьРезерв=Элемент.ТекущиеДанные[Элемент.ДанныеФлажка];
	//
	////БИТ_Егоров+
	////ТекСтрока = Элемент.ТекущиеДанные;
	//ТекСтрока = Элементы.НачислениеРезерва.ПодчиненныеЭлементы.Данные.ТекущиеДанные;
	//Если Элемент.Имя = "РезервНачисленАвтоматически" Тогда
	//	Если ТекСтрока.НачислятьРезерв Тогда
	//		ТекСтрока.НачислятьРезерв = Ложь;
	//	Иначе
	//		ТекСтрока.ПроцентСписания = 0;
	//		ТекСтрока.СуммаСписания = 0;
	//	КонецЕсли;
	//	
	//ИначеЕсли Элемент.Имя = "БИТ_НачислятьРезерв" Тогда
	//	
	//	Если  ТекСтрока.БИТ_НачислятьРезерв Тогда
	//		ТекСтрока.ПроцентСписания = 100;
	//		ТекСтрока.СуммаСписания = ТекСтрока.СуммаЗадолженности;
	//	ИначеЕсли Не ТекСтрока.БИТ_НачислятьРезерв Тогда
	//		ТекСтрока.ПроцентСписания = 0;
	//		ТекСтрока.СуммаСписания = 0;
	//	КонецЕсли;
	//КонецЕсли;
	//
	//	 //БИТ_Егоров- 
	//	//Если ТекСтрНачислятьРезерв Тогда
	//		//ПроцентСписания=100;
	//	//КонецЕсли;
	
	ТекСтрока = Элементы.НачислениеРезерва.ПодчиненныеЭлементы.Данные.ТекущиеДанные;
	Если  не ТекСтрока.БИТ_НачислятьРезерв  Тогда
		ТекСтрока.БИТ_НачислятьРезерв = ложь;
		ТекСтрока.ПроцентСписания = 0;
		ТекСтрока.СуммаСписания = 0;
	Иначе
		СБ_ИзменитьПроцентСписанияИСуммуСписания(ТекСтрока);
	КонецЕсли;
	//-СБ ПИскунова В 15.06.2016 #2366 Требования изменились

КонецПроцедуры

&НаСервере
Функция ПровереноКазначействомПриИзменении_Сервер()
	
	Если Объект.БИТ_ПровереноКазначейством Тогда
		Элементы.Данные.ПодчиненныеЭлементы.БИТ_НачислятьРезерв.ТолькоПросмотр = Истина;
		Элементы.Данные.ПодчиненныеЭлементы.РезервНачисленАвтоматически.ТолькоПросмотр = Истина;
		//ЭлементыФормы.БИТ_КорректировкаРезерва.ТолькоПросмотр = Истина;
		
		//ОК+ Аверьянова 20.06.14 #822#
		//ЭлементыФормы.КоманднаяПанельДанные.Доступность = Ложь;
		ОрганизацияОКЕЙ = Справочники.Организации.НайтиПоКоду("000000045"); 
 
		Элементы.Панель1.Доступность = Истина;
		КнопкаЗаполнить = Элементы.Найти("Заполнить");
	 	КнопкаДействия1 = Элементы.Найти("ДанныеЗаполнитьДанныеПоУчету");
		КнопкаДействия2 = Элементы.Найти("ДанныеЗаполнитьДанныеПоРегистру");
		КнопкаДействияКР = Элементы.Найти("ДанныеЗаполнитьЗакладкуКорректировкаРезерва"); 
		Если  Объект.Организация = ОрганизацияОКЕЙ Тогда
			КнопкаЗаполнить.Доступность = Истина;
			КнопкаДействия1.Доступность = Ложь;
		    КнопкаДействия2.Доступность = Ложь;
		    КнопкаДействияКР.Доступность = истина;
		Иначе
			КнопкаЗаполнить.Доступность = Ложь;
			КнопкаДействия1.Доступность = Ложь;
		    КнопкаДействия2.Доступность = Ложь;
		    КнопкаДействияКР.Доступность = Ложь;
		КонецЕсли;	
		//ОК- Аверьянова
		
	Иначе
		Элементы.Данные.ТолькоПросмотр = Ложь;
		Элементы.Данные.ПодчиненныеЭлементы.БИТ_НачислятьРезерв.ТолькоПросмотр = Ложь;
		Элементы.Данные.ПодчиненныеЭлементы.РезервНачисленАвтоматически.ТолькоПросмотр = Ложь;
		Элементы.БИТ_КорректировкаРезерва.ТолькоПросмотр = Ложь;

		Элементы.Панель1.Доступность = Истина;
		//ОК+ Аверьянова 20.06.14 #822#  
		УстановитьДоступностьКнопокПодменю();
		//ОК- Аверьянова 

	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПровереноКазначействомПриИзменении(Элемент)
	ПровереноКазначействомПриИзменении_Сервер();;		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Стандартные действия при создании на сервере
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
		
	СписокИспользумеых = Счета();
		
	Если Объект.Ссылка.Пустая() Тогда

		// Заполнить реквизиты значениями по умолчанию.
		рс_ОбщийМодуль.ЗаполнитьШапкуДокумента(Объект, Объект.Ссылка.Метаданные(), ПользователиКлиентСервер.ТекущийПользователь(), , ,Параметры.ЗначениеКопирования);
		//+ СБ Прудникова 2011-12-21
		Объект.Дата = КонецМесяца(ТекущаяДата());
		///
		//ОК+ Аверьянова 01.07.14 #832#
		//ПериодФормирования	= ТекущаяДата();
		Объект.ПериодФормирования	= Объект.Дата;
		//ОК- Аверьянова 01.07.14 #832#
		ОбновитьДаты();
		
		//Объект
		ЗапросФО = Новый Запрос;
		ЗапросФО.Текст = "ВЫБРАТЬ
		|             бит_му_Настройки.Значение
		|ИЗ
		|             РегистрСведений.бит_му_Настройки КАК бит_му_Настройки
		|ГДЕ
		|             бит_му_Настройки.ИмяНастройки = &ИмяНастройки";
		ЗапросФО.УстановитьПараметр("ИмяНастройки", "ФедеральныйОфисСПБ");
		Выборка = ЗапросФО.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Объект.ОбъектСтроительства = Выборка.Значение;
		Иначе
			Объект.ОбъектСтроительства = ПредопределенноеЗначение("Справочник.ОбъектыСтроительства.ПустаяСсылка");
		КонецЕсли;
		
		//бит_БК_ЦФО
		Объект.бит_БК_ЦФО=Справочники.Подразделения.НайтиПоНаименованию("Бухгалтерия",Истина);

	КонецЕсли;
	
	Инициализировать_Вызов_Функции();
	
	//+ СБ Прудникова 2011-12-21

	Модифицированность = Ложь;
		
КонецПроцедуры

//БИТ_Егоров-

//ОК+ Аверьянова 20.06.14 #814#
&НаКлиенте
Процедура ДанныеПроцентСписанияПриИзменении(Элемент)
	ТекСтрока = Элементы.Данные.ТекущиеДанные;  	
	ТекСтрока.СуммаСписания =  Окр(ТекСтрока.СуммаЗадолженности*ТекСтрока.ПроцентСписания/100,2);
КонецПроцедуры
//ОК- Аверьянова

&НаСервере
Функция УстановитьСчета_Вызов_Функции(ПолученныйСписок)
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.УстановитьСчета(ПолученныйСписок);
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаСервере
Функция ЗаполнитьДанныеПоРегиструДебиторскаяЗадолженность_Вызов_Функции()
	_объект=РеквизитФормыВЗначение("Объект");
	результат = _объект.ЗаполнитьДанныеПоРегиструДебиторскаяЗадолженность();
	ЗначениеВРеквизитФормы(_объект, "Объект");
	Возврат результат;
КонецФункции

&НаСервере
Функция ЗаполнитьДанные_Вызов_Функции()
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.ЗаполнитьДанные(СписокИспользумеых);
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаСервере
Функция БИТ_ЗаполнитьКорректировкуРезерва_Вызов_Функции()
	_объект=РеквизитФормыВЗначение("Объект");
	результат = _объект.БИТ_ЗаполнитьКорректировкуРезерва();
	ЗначениеВРеквизитФормы(_объект, "Объект");
	Возврат результат;
КонецФункции

&НаСервере
Функция Инициализировать_Вызов_Функции()
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.Инициализировать();
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьКнопокПодменю();
	
	//Бит_Егоров+
	Если Объект.БИТ_ПровереноКазначейством Тогда
		Элементы.Данные.ТолькоПросмотр = Истина;
		Элементы.БИТ_КорректировкаРезерва.ТолькоПросмотр = Истина;

		//Элементы.КоманднаяПанель.Доступность = Ложь;
		Элементы.Данные.КоманднаяПанель.Доступность = Ложь;
	Иначе
		Элементы.Данные.ТолькоПросмотр = Ложь;
		Элементы.БИТ_КорректировкаРезерва.ТолькоПросмотр = Ложь;

		//Элементы.КоманднаяПанель.Доступность = Истина;
		Элементы.Данные.КоманднаяПанель.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

//+СБ ПИскунова В 09.06.2016 #2366 Требования изменились
&НаКлиенте
Процедура РезервНачисленАвтоматическиПриИзменении(Элемент)  	
	
	ТекСтрока = Элементы.НачислениеРезерва.ПодчиненныеЭлементы.Данные.ТекущиеДанные;
	Если Не ТекСтрока.НачислятьРезерв Тогда
		ТекСтрока.НачислятьРезерв = Ложь;
		ТекСтрока.ПроцентСписания = 0;
		ТекСтрока.СуммаСписания = 0; 			
	КонецЕсли;  
	Элементы.Данные.ПодчиненныеЭлементы.БИТ_НачислятьРезерв.ТолькоПросмотр  =  ТекСтрока.НачислятьРезерв;
	Элементы.Данные.ПодчиненныеЭлементы.РезервНачисленАвтоматически.ТолькоПросмотр  =  не ТекСтрока.НачислятьРезерв;
	
КонецПроцедуры


&НаКлиенте
Процедура ДнейПросрочкиПриИзменении(Элемент)  		
	ТекСтрока = Элементы.НачислениеРезерва.ПодчиненныеЭлементы.Данные.ТекущиеДанные;
	СБ_ИзменитьПроцентСписанияИСуммуСписания(ТекСтрока);	 
КонецПроцедуры

&НаКлиенте
Процедура СБ_ИзменитьПроцентСписанияИСуммуСписания(ТекСтрока) 	
	
	Если ТекСтрока.ДнейПросрочки = 0  Тогда
		ТекСтрока.ПроцентСписания = 0;
		ТекСтрока.СуммаСписания = 0;
		ТекСтрока.НачислятьРезерв = Ложь;
		ТекСтрока.БИТ_НачислятьРезерв = Ложь;
	ИначеЕсли  ТекСтрока.ДнейПросрочки > 365 * 3  Тогда   
		ТекСтрока.ПроцентСписания = 100;
		ТекСтрока.СуммаСписания = ТекСтрока.СуммаЗадолженности;
	ИначеЕсли  ТекСтрока.ДнейПросрочки > 365 * 2  Тогда   
		ТекСтрока.ПроцентСписания = 75;
		ТекСтрока.СуммаСписания = ТекСтрока.СуммаЗадолженности * 75 / 100;
	ИначеЕсли  ТекСтрока.ДнейПросрочки > 365  Тогда   
		ТекСтрока.ПроцентСписания = 40;
		ТекСтрока.СуммаСписания = ТекСтрока.СуммаЗадолженности * 40 / 100;  		
	КонецЕсли; 
	ТекСтрока.НачислятьРезерв = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПриИзменении(Элемент)
	ТекСтрока = Элементы.НачислениеРезерва.ПодчиненныеЭлементы.Данные.ТекущиеДанные;
	Если ТекСтрока.СрокИсполнения < КонецДня(Объект.ПериодФормирования) и ЗначениеЗаполнено(ТекСтрока.СрокИсполнения) Тогда
		ТекСтрока.ДнейПросрочки = Окр( ( КонецДня(Объект.ПериодФормирования) - ТекСтрока.СрокИсполнения)/86400)-1; 
	Иначе
		ТекСтрока.ДнейПросрочки =0; 
	КонецЕсли; 
	СБ_ИзменитьПроцентСписанияИСуммуСписания(ТекСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеПриАктивизацииСтроки(Элемент)
	//ОК+ Довбешка Т. 01.07.2016
	Если НЕ Элемент.ТекущиеДанные = неопределено Тогда
	//ОК-	
		ТекСтрока = Элементы.НачислениеРезерва.ПодчиненныеЭлементы.Данные.ТекущиеДанные;	
		Элементы.Данные.ПодчиненныеЭлементы.БИТ_НачислятьРезерв.ТолькоПросмотр  =  ТекСтрока.НачислятьРезерв;
		Элементы.Данные.ПодчиненныеЭлементы.РезервНачисленАвтоматически.ТолькоПросмотр  =  не ТекСтрока.НачислятьРезерв;
	//ОК+ Довбешка Т. 01.07.2016
	КонецЕсли;
	//ОК-	
КонецПроцедуры
//-СБ ПИскунова В 09.06.2016 #2366 Требования изменились
