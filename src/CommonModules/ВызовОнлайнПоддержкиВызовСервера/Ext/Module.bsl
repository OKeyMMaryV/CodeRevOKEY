﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Получает из регистра сведений путь к исполняемому файлу.
//
// Параметры:
//		ИдентификаторКлиента	- УникальныйИдентификатор - Идентификатор клиента (программы) 1С.
// 		
// ВозвращаемоеЗначение:
// 		Строка   - Путь к исполняемому файлу на ПК текущего пользователя.
//
Функция РасположениеИсполняемогоФайла(ИдентификаторКлиента) Экспорт
	
	Возврат ХранилищеОбщихНастроек.Загрузить("ПутиИсполняемыхФайловВызовОнлайнПоддержки", ИдентификаторКлиента);
	
КонецФункции

// Получает из регистра сведений параметры для запуска приложения.
//
// Параметры:
//		Пользователь  - УникальныйИдентификатор - Текущий пользователь информационной базы.
//
// ВозвращаемоеЗначение:
//		Структура  - Настройки пользователя для запуска приложения.
//
Функция НастройкиУчетнойЗаписиПользователя() Экспорт 
	
	НастройкиПользователя = ВызовОнлайнПоддержки.НастройкиПользователя();
	НастройкиПользователяХранилище = ХранилищеОбщихНастроек.Загрузить("УчетныеЗаписиПользователейВызовОнлайнПоддержки", "НастройкиУчетныхДанных");
	
	Если НЕ НастройкиПользователяХранилище = Неопределено Тогда
		ЗаполнитьЗначенияСвойств(НастройкиПользователя, НастройкиПользователяХранилище);
		Если НастройкиПользователяХранилище.Свойство("ВидимостьКнопки1СБухфон") Тогда
			НастройкиПользователя.ВидимостьКнопкиВызовОнлайнПоддержки = НастройкиПользователяХранилище.ВидимостьКнопки1СБухфон;
		КонецЕсли;
	КонецЕсли;
	
	Возврат НастройкиПользователя;
	
КонецФункции
	
#КонецОбласти
 


