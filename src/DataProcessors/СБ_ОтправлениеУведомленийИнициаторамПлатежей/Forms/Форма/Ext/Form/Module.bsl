﻿
&НаКлиенте
Процедура ОтправитьУведомления(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;		
	КонецЕсли; 
	
	БезОшибок = ОтправитьУведомленияНаСервере();
	Если Не БезОшибок Тогда
		Возврат;
	КонецЕсли;  	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-12-22 (#2951)
	//ПараметрыФормы = Новый Структура;
	//ПараметрыФормы.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.бит_фн_ВидыОперацийОбработкиЗаписейРегистраОповещений.ОтправитьОповещения"));
	//
	//ОткрытьФорму("Обработка.бит_фн_ОбработкаЗаписейРегистраОповещений.Форма.ФормаУправляемая",ПараметрыФормы,ЭтаФорма);
	//Заменено на:
	ПоказатьПредупреждение(,НСтр("ru='Оповещения успешно сформированы'"),30);
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-12-22 (#2951)
	
КонецПроцедуры

&НаСервере
Функция ОтправитьУведомленияНаСервере()

	Аналитика_Инициатор = СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("ДопРеквизит_Инициатор");
	НастройкаДоставки	= СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("НастройкаДоставки");
	ШаблонСообщений		= СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("ШаблонСообщений");
	
	Если Не (ЗначениеЗаполнено(НастройкаДоставки) И ЗначениеЗаполнено(ШаблонСообщений)) Тогда
		Сообщить("В настройках казначейства необходимо задать параметры отправки уведомлений!");
		Возврат Ложь;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	бит_фн_ШаблоныСообщений.Сообщение_Заголовок,
	|	бит_фн_ШаблоныСообщений.Сообщение_Текст,
	|	бит_фн_ШаблоныСообщений.Сообщение_Подпись,
	|	бит_фн_ШаблоныСообщений.ТипТекстаСообщения
	|ИЗ
	|	Справочник.бит_фн_ШаблоныСообщений КАК бит_фн_ШаблоныСообщений
	|ГДЕ
	|	бит_фн_ШаблоныСообщений.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка",	ШаблонСообщений);	 //Шаблоны сообщений
	РезультатЗапроса = Запрос.Выполнить();	
	
	Шаблон = РезультатЗапроса.Выбрать();
	Шаблон.Следующий();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СписаниеСРасчетногоСчета.Ссылка КАК Предмет,
	|	ДополнительныеАналитики_Инициаторы.ЗначениеАналитики КАК Инициатор,
	|	СписаниеСРасчетногоСчета.Организация,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеСРасчетногоСчета.Организация) КАК ОрганизацияПредставление,
	|	СписаниеСРасчетногоСчета.Контрагент,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеСРасчетногоСчета.Контрагент) КАК КонтрагентПредставление,
	|	СписаниеСРасчетногоСчета.Номер,
	|	СписаниеСРасчетногоСчета.Дата,
	|	СписаниеСРасчетногоСчета.СуммаДокумента,
	|	СписаниеСРасчетногоСчетабит_РаспределениеБюджета.Аналитика_1 КАК НомерЗаявки,
	|	бит_БК_Инициаторы.Email КАК АдресПолучателя,
	|	бит_БК_Инициаторы.Пользователь,
	|	СписаниеСРасчетногоСчета.НазначениеПлатежа,
	|	СписаниеСРасчетногоСчета.НомерВходящегоДокумента       
	|ИЗ
	|	РегистрСведений.бит_ДополнительныеАналитики КАК ДополнительныеАналитики_Инициаторы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СписаниеСРасчетногоСчета КАК СписаниеСРасчетногоСчета
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_фн_Оповещения КАК бит_фн_Оповещения
	|			ПО СписаниеСРасчетногоСчета.Ссылка = бит_фн_Оповещения.СБ_Предмет
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СписаниеСРасчетногоСчета.бит_РаспределениеБюджета КАК СписаниеСРасчетногоСчетабит_РаспределениеБюджета
	|			ПО СписаниеСРасчетногоСчета.Ссылка = СписаниеСРасчетногоСчетабит_РаспределениеБюджета.Ссылка
	|				И (СписаниеСРасчетногоСчетабит_РаспределениеБюджета.НомерСтроки = 1)
	|		ПО ДополнительныеАналитики_Инициаторы.Объект = СписаниеСРасчетногоСчета.Ссылка
	|			И (ДополнительныеАналитики_Инициаторы.Аналитика = &Аналитика_Инициатор)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.бит_БК_Инициаторы КАК бит_БК_Инициаторы
	|		ПО ДополнительныеАналитики_Инициаторы.ЗначениеАналитики = бит_БК_Инициаторы.Ссылка
	|ГДЕ
	|	СписаниеСРасчетногоСчета.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И СписаниеСРасчетногоСчета.Проведен
	|	И СписаниеСРасчетногоСчета.Организация = &Организация
	|	И бит_фн_Оповещения.СБ_Предмет ЕСТЬ NULL 
	|	И (ВЫРАЗИТЬ(ДополнительныеАналитики_Инициаторы.ЗначениеАналитики КАК Справочник.бит_БК_Инициаторы)) <> ЗНАЧЕНИЕ(Справочник.бит_БК_Инициаторы.ПустаяСсылка)";
	Запрос.УстановитьПараметр("Аналитика_Инициатор",	Аналитика_Инициатор);	 //Виды дополнительных аналитик
	Запрос.УстановитьПараметр("НачалоПериода",			НачалоДня(Объект.Период));	 //Дата
	Запрос.УстановитьПараметр("ОкончаниеПериода",		КонецДня(Объект.Период));	 //Дата
	Запрос.УстановитьПараметр("Организация",			Объект.Организация);	 //Организации
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		//Сообщить("Документы к отправке не найдены");
		Возврат Истина;
	КонецЕсли; 
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Сообщение_Заголовок = Шаблон.Сообщение_Заголовок;
		Сообщение_Заголовок = СтрЗаменить(Сообщение_Заголовок, "{{ТекущийОбъект.Номер}}", Выборка.Номер);
		Сообщение_Заголовок = СтрЗаменить(Сообщение_Заголовок, "{{ТекущийОбъект.Дата}}",  Выборка.Дата);
		
		Сообщение_Текст	= Шаблон.Сообщение_Текст;
		Сообщение_Текст = СтрЗаменить(Сообщение_Текст, "{{ТекущийОбъект.Номер}}", 				Выборка.Номер);
		Сообщение_Текст = СтрЗаменить(Сообщение_Текст, "{{ТекущийОбъект.Дата}}",  				Выборка.Дата);
		//ОК+ Аверьянова 14.08.15 - добавлена также строка 66 в запрос
		Сообщение_Текст = СтрЗаменить(Сообщение_Текст, "{{ТекущийОбъект.НомерВходящегоДокумента}}",Выборка.НомерВходящегоДокумента);  
		//ОК-
		Сообщение_Текст = СтрЗаменить(Сообщение_Текст, "{{НомерЗаявки}}",  						Выборка.НомерЗаявки);
		Сообщение_Текст = СтрЗаменить(Сообщение_Текст, "{{ТекущийОбъект.Организация}}",  		Выборка.ОрганизацияПредставление);
		Сообщение_Текст = СтрЗаменить(Сообщение_Текст, "{{ТекущийОбъект.Контрагент}}",  		Выборка.КонтрагентПредставление);
		Сообщение_Текст = СтрЗаменить(Сообщение_Текст, "{{ТекущийОбъект.СуммаДокумента}}",  	Формат(Выборка.СуммаДокумента, "ЧДЦ=2"));
		Сообщение_Текст = СтрЗаменить(Сообщение_Текст, "{{ТекущийОбъект.НазначениеПлатежа}}",  	Выборка.НазначениеПлатежа);
		
		Сообщение_Подпись = Шаблон.Сообщение_Подпись;
		
		МенеджерЗаписи = РегистрыСведений.бит_фн_Оповещения.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Статус 				= Перечисления.бит_фн_СтатусыОтправкиОповещений.ГотовоКОтправке;
		МенеджерЗаписи.НастройкаДоставки	= НастройкаДоставки;
		МенеджерЗаписи.Пользователь 		= Выборка.Пользователь;
		МенеджерЗаписи.ИД					= Строка(Новый УникальныйИдентификатор);
		
		МенеджерЗаписи.АдресПолучателя 		= Выборка.АдресПолучателя;
		МенеджерЗаписи.Сообщение_Заголовок 	= Сообщение_Заголовок;
		МенеджерЗаписи.Сообщение_Текст 		= Сообщение_Текст;
		МенеджерЗаписи.Сообщение_Подпись 	= Сообщение_Подпись;
		
		МенеджерЗаписи.ТипТекстаСообщения	= Шаблон.ТипТекстаСообщения;
		МенеджерЗаписи.СБ_Предмет			= Выборка.Предмет;
		
		МенеджерЗаписи.Записать(Ложь);
		
	КонецЦикла; 
	
	Возврат Истина;
	
КонецФункции
 